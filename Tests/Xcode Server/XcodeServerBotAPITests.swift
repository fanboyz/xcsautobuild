//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class XcodeServerBotAPITests: XCTestCase {
    
    var api: XcodeServerBotAPI!
    var mockedCreateBotRequest: MockXCSRequest<[String: AnyObject], Void>!
    var mockedGetBotsRequest: MockXCSRequest<Void, [RemoteBot]>!
    var mockedDeleteBotRequest: MockXCSRequest<String, Void>!
    var mockedGetBotRequest: MockXCSRequest<String, NSData>!
    var mockedTemplateLoader: MockBotTemplateLoader!
    let endpoint = "https://seans-macbook-pro-2.local:20343/api/"
    let botID = "123"
    let botData: NSData = {
        return FlexiJSON(dictionary: testBot.toJSON()).data!
    }()
    let botJSON = ["name": "template"]
    
    override func setUp() {
        super.setUp()
        mockedCreateBotRequest = MockXCSRequest()
        mockedGetBotsRequest = MockXCSRequest()
        mockedDeleteBotRequest = MockXCSRequest()
        mockedGetBotRequest = MockXCSRequest()
        mockedTemplateLoader = MockBotTemplateLoader()
        api = XcodeServerBotAPI(
            createBotRequest: AnyXCSRequest(mockedCreateBotRequest),
            getBotsRequest: AnyXCSRequest(mockedGetBotsRequest),
            deleteBotRequest: AnyXCSRequest(mockedDeleteBotRequest),
            getBotRequest: AnyXCSRequest(mockedGetBotRequest),
            botTemplateLoader: mockedTemplateLoader
        )
    }
    
    // MARK: - createBot
    
    func test_createBot_shouldSendRequest() {
        stubValidBotTemplate()
        createBot()
        XCTAssert(mockedCreateBotRequest.didSend)
    }

    func test_createBot_shouldRenamedSendTemplateBot() {
        let expected = ["name": "xcsautobuild [master]"]
        stubValidBotTemplate()
        createBot()
        XCTAssertEqual(mockedCreateBotRequest.invokedData! as NSDictionary, expected)
    }

    func test_createBot_shouldNotSendRequest_whenTemplateIsNotDictionary() {
        stubInvalidBotTemplate()
        createBot()
        XCTAssertFalse((mockedCreateBotRequest.didSend))
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
        XCTAssertEqual(fetchBotTemplates(), [BotTemplate(name: "bot1", data: botData)])
    }

    func test_fetchBotTemplates_shouldIgnoreBotsWithUnexpectedData() {
        stubGetBotsResponse()
        stubBadGetBotResponse()
        XCTAssert(fetchBotTemplates().isEmpty)
    }

    // MARK: - Helpers

    func createBot() {
        api.createBot(forBranch: Branch(name: "master"))
    }

    func stubValidBotTemplate() {
        mockedTemplateLoader.stubbedTemplate = BotTemplate(name: "", data: FlexiJSON(dictionary: botJSON).data!)
    }

    func stubInvalidBotTemplate() {
        mockedTemplateLoader.stubbedTemplate = BotTemplate(name: "", data: "not dictionary".dataUsingEncoding(NSUTF8StringEncoding)!)
    }

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
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: NSData(), statusCode: 200)
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
