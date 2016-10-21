//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class XcodeServerBotAPITests: XCTestCase {
    
    var api: XcodeServerBotAPI!
    var mockedGetBotsRequest: MockXCSRequest<Void, [RemoteBot]>!
    var mockedDeleteBotRequest: MockXCSRequest<String, Void>!
    var mockedGetBotRequest: MockXCSRequest<String, Data>!
    let botID = "123"
    let botData: Data = {
        return load("bot_get_response", "json")
    }()
    let botJSON = ["name": "template"]
    
    override func setUp() {
        super.setUp()
        mockedGetBotsRequest = MockXCSRequest()
        mockedDeleteBotRequest = MockXCSRequest()
        mockedGetBotRequest = MockXCSRequest()
        api = XcodeServerBotAPI(
            getBotsRequest: AnyXCSRequest(mockedGetBotsRequest),
            deleteBotRequest: AnyXCSRequest(mockedDeleteBotRequest),
            getBotRequest: AnyXCSRequest(mockedGetBotRequest)
        )
    }
    
    // MARK: - getBots

    func test_getBots_shouldSendNetworkRequest() {
        getBots()
        XCTAssert(mockedGetBotsRequest.didSend)
    }

    func test_getBots_shouldComplete() {
        var didComplete = false
        api.getBots { _ in
            didComplete = true
        }
        XCTAssert(didComplete)
    }

    func test_getBots_shouldCompleteWithEmptyArrayInsteadOfNil() {
        api.getBots { bots in
            XCTAssertNotNil(bots)
        }
    }

    // MARK: - deleteBot

    func test_deleteBot_shouldSendNetworkRequest() {
        api.deleteBot(id: botID)
        XCTAssert(mockedDeleteBotRequest.didSend)
    }

    // MARK: - deleteBot(forBranch:)

    func test_deleteBot_shouldGetBots() {
        api.deleteBot(forBranch: testBranch)
        XCTAssert(mockedGetBotsRequest.didSend)
    }

    func test_deleteBot_shouldDeleteMatchingBot() {
        stubMatchingBotResponse()
        api.deleteBot(forBranch: testBranch)
        XCTAssert(mockedDeleteBotRequest.didSend)
        XCTAssertEqual(mockedDeleteBotRequest.invokedData, botID)
    }

    func test_deleteBot_shouldNotDeleteUnmatchingBots() {
        stubUnmatchingBotResponse()
        api.deleteBot(forBranch: testBranch)
        XCTAssertFalse(mockedDeleteBotRequest.didSend)
    }

    func test_deleteBot_shouldDeleteMatchingBot_whenOtherUnmatchingBots() {
        stubMixedBotResponse()
        api.deleteBot(forBranch: testBranch)
        XCTAssertEqual(mockedDeleteBotRequest.didSendCount, 1)
        XCTAssertEqual(mockedDeleteBotRequest.invokedData, botID)
    }

    // MARK: - fetchBotTemplates

    func test_fetchBotTemplates_shouldReturnEmptyArray_whenNoBots() {
        XCTAssert(fetchBotTemplates().isEmpty)
    }

    func test_fetchBotTemplates_shouldConvertBotsToTemplates() {
        stubGetBotsResponse()
        stubGetBotResponse()
        XCTAssertEqual(fetchBotTemplates(), [BotTemplate(name: testBotName, data: botData)])
    }

    func test_fetchBotTemplates_shouldIgnoreBotsWithUnexpectedData() {
        stubGetBotsResponse()
        stubBadGetBotResponse()
        XCTAssert(fetchBotTemplates().isEmpty)
    }

    // MARK: - Helpers

    func getBots() {
        api.getBots { b in }
    }

    func stubMatchingBotResponse() {
        stubGetBotsResponse(with: [RemoteBot(id: botID, name: formattedTestBranchName())])
    }

    func stubUnmatchingBotResponse() {
        stubGetBotsResponse(with: [RemoteBot(id: botID, name: "unmatching name")])
    }

    func stubMixedBotResponse() {
        stubGetBotsResponse(with: [
            RemoteBot(id: botID, name: formattedTestBranchName()),
            RemoteBot(id: botID, name: "unmatching name")
        ])
    }

    func stubGetBotsResponse() {
        stubGetBotsResponse(with: [RemoteBot(id: "123", name: "bot1")])
    }

    func stubGetBotsResponse(with bots: [RemoteBot]) {
        mockedGetBotsRequest.stubbedResponse = XCSResponse(data: bots, statusCode: 200)
    }

    func stubGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: botData, statusCode: 200)
    }

    func stubBadGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: Data(), statusCode: 200)
    }

    func formattedTestBranchName() -> String {
        return "xcsautobuild [\(testBranch.name)]"
    }

    func fetchBotTemplates() -> [BotTemplate] {
        var templates: [BotTemplate]!
        api.fetchBotTemplates { t in
            templates = t
        }
        return templates
    }
}
