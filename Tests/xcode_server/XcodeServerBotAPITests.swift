//
//  XcodeServerBotAPITests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class XcodeServerBotAPITests: XCTestCase {
    
    var api: XcodeServerBotAPI!
    var mockedNetwork: MockNetwork!
    var mockedCreateBotRequest: MockXCSRequest<Bot, Void>!
    var mockedGetBotsRequest: MockXCSRequest<Void, [RemoteBot]>!
    var mockedDeleteBotRequest: MockXCSRequest<String, Void>!
    let endpoint = "https://seans-macbook-pro-2.local:20343/api/"
    let botID = "123"
    
    override func setUp() {
        super.setUp()
        mockedNetwork = MockNetwork()
        mockedCreateBotRequest = MockXCSRequest()
        mockedGetBotsRequest = MockXCSRequest()
        mockedDeleteBotRequest = MockXCSRequest()
        api = XcodeServerBotAPI(
            network: mockedNetwork,
            createBotRequest: AnyXCSRequest(mockedCreateBotRequest),
            getBotsRequest: AnyXCSRequest(mockedGetBotsRequest),
            deleteBotRequest: AnyXCSRequest(mockedDeleteBotRequest)
        )
    }
    
    // MARK: - createBot
    
    func test_createBot_shouldSendRequest() {
        api.createBot(forBranch: Branch(name: "master"))
        XCTAssert(mockedCreateBotRequest.didSend)
    }

    // MARK: - getBots

    func test_getBots_shouldSendNetworkRequest() {
        api.getBots { _ in }
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

    // MARK: - Helpers

    func getBots() {
        api.getBots { b in }
    }

    func stubMatchingBotResponse() {
        mockedGetBotsRequest.stubbedResponse = [RemoteBot(id: botID, name: testBranch.name)]
    }

    func stubUnmatchingBotResponse() {
        mockedGetBotsRequest.stubbedResponse = [RemoteBot(id: botID, name: "unmatching name")]
    }

    func stubMixedBotResponse() {
        mockedGetBotsRequest.stubbedResponse = [
            RemoteBot(id: botID, name: testBranch.name),
            RemoteBot(id: botID, name: "unmatching name")
        ]
    }
}
