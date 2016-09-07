//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class XCSRequestTests: XCTestCase {
    
    var request: TestXCSRequest!
    var mockedNetwork: MockNetwork { return request.mockedNetwork }
    
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
        send()
        XCTAssert(request.didCreateRequest)
    }

    func test_send_shouldParseResponse() {
        send()
        XCTAssert(request.didParse)
    }

    func test_send_shouldCallCompletion() {
        var didCallCompletion = false
        request.send("") { _ in
            didCallCompletion = true
        }
        XCTAssert(didCallCompletion)
    }

    // MARK: - send (sync)

    func test_sendSync_shouldCreateRequest() {
        request.send("")
        XCTAssert(request.didCreateRequest)
    }

    func test_sendSync_shouldParseResponse() {
        request.send("")
        XCTAssert(request.didParse)
    }

    func test_sendSync_shouldBlockUntilFinished() {
        let parsed = "hello".dataUsingEncoding(NSUTF8StringEncoding)!
        mockedNetwork.stubbedResponse = parsed
        let response = request.send("")
        XCTAssertEqual(response, parsed)
    }

    // MARK: - Helpers

    func send() {
        request.send("") { _ in }
    }

    class TestXCSRequest: XCSRequest {

        var mockedNetwork = MockNetwork()
        var network: Network {
            return mockedNetwork
        }

        var didCreateRequest = false
        func createRequest(data: String) -> HTTPRequest {
            didCreateRequest = true
            return testRequest
        }

        var didParse = false
        func parse(response data: NSData) -> NSData? {
            didParse = true
            return data
        }
    }
}
