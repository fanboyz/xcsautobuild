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
    let endpoint = "https://seans-macbook-pro-2.local:20343/api/"
    
    override func setUp() {
        super.setUp()
        mockedNetwork = MockNetwork()
        api = XcodeServerBotAPI(network: mockedNetwork)
    }
    
    // MARK: - createBot
    
    func test_createBot_shouldSendNetworkRequest() {
        let expectedURL = endpoint + "bots"
        api.createBot(forBranch: Branch(name: "master"))
        XCTAssert(mockedNetwork.didSendRequest)
        XCTAssertEqual(mockedNetwork.invokedRequest?.method, .post)
        XCTAssertEqual(mockedNetwork.invokedRequest?.url, expectedURL)
    }

    // MARK: - getBots

    func test_getBots_shouldSendNetworkRequest() {
        let expectedURL = endpoint + "bots"
        getBots()
        XCTAssert(mockedNetwork.didSendRequest)
        XCTAssertEqual(mockedNetwork.invokedRequest?.method, .delete)
        XCTAssertEqual(mockedNetwork.invokedRequest?.url, expectedURL)
        XCTAssertNil(mockedNetwork.invokedRequest?.jsonBody)
    }

    // MARK: - Helpers

    func getBots() {
        api.getBots { b in }
    }
}
