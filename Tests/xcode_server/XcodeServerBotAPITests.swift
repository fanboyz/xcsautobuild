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
    
    override func setUp() {
        super.setUp()
        mockedNetwork = MockNetwork()
        api = XcodeServerBotAPI(network: mockedNetwork)
    }
    
    // MARK: - createBot
    
    func test_createBot_shouldSendNetwork() {
        let expectedURL = "https://seans-macbook-pro-2.local:20343/api/bots"
        api.createBot(forBranch: "master")
        XCTAssert(mockedNetwork.didSendRequest)
        XCTAssertEqual(mockedNetwork.invokedRequest?.method, .post)
        XCTAssertEqual(mockedNetwork.invokedRequest?.url, expectedURL)
    }
}
