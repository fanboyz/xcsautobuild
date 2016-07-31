//
//  XCSRequestTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class XCSRequestTests: XCTestCase {
    
    var request: TestXCSRequest!
    
    override func setUp() {
        super.setUp()
        request = TestXCSRequest()
    }

    // MARK: - endpoint

    func test_endpoint() {
        XCTAssertEqual(request.endpoint, "https://seans-macbook-pro-2.local:20343/api/")
    }
    
    // MARK: - send
    
    func test_send_shouldCreateRequest() {
        request.send("") { _ in }
        XCTAssert(request.didCreateRequest)
    }

    func test_send_shouldParseResponse() {
        request.send("") { _ in }
        XCTAssert(request.didParse)
    }

    func test_send_shouldCallCompletion() {
        var didCallCompletion = false
        request.send("") { _ in
            didCallCompletion = true
        }
        XCTAssert(didCallCompletion)
    }

    // MARK: - Helpers

    class TestXCSRequest: XCSRequest {

        var network: Network = MockNetwork()

        var didCreateRequest = false
        func createRequest(data: String) -> HTTPRequest {
            didCreateRequest = true
            return testRequest
        }

        var didParse = false
        func parse(response data: NSData) -> String? {
            didParse = true
            return nil
        }
    }
}
