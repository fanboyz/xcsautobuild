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

    func test_send_shouldNotParseResponse_whenNoResponseData() {
        send()
        XCTAssertFalse(request.didParse)
    }

    func test_send_shouldParseResponse_whenResponseData() {
        stubResponse()
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

    func test_send_shouldCompleteWithNil_whenNoData() {
        stubResponse(data: nil)
        XCTAssertNil(send())
    }

    func test_send_shouldCompleteWithNil_whenNoStatusCode() {
        stubResponse(statusCode: nil)
        XCTAssertNil(send())
    }

    // MARK: - send (sync)

    func test_sendSync_shouldCreateRequest() {
        request.send("")
        XCTAssert(request.didCreateRequest)
    }

    func test_sendSync_shouldNotParseResponse_whenNoResponseData() {
        request.send("")
        XCTAssertFalse(request.didParse)
    }

    func test_sendSync_shouldParseResponse_whenResponseData() {
        stubResponse()
        request.send("")
        XCTAssert(request.didParse)
    }

    func test_sendSync_shouldBlockUntilFinished() {
        let parsed = "hello".data(using: String.Encoding.utf8)!
        mockedNetwork.stubbedResponse = parsed
        mockedNetwork.stubbedStatusCode = 200
        let response = request.send("")
        XCTAssertEqual(response?.data, parsed)
    }

    // MARK: - Helpers

    func send() -> XCSResponse<NSData>? {
        var response: XCSResponse<NSData>?
        request.send("") { r in
            response = r
        }
        return response
    }

    func stubResponse(data: Data? = Data(), statusCode: Int? = 200) {
        mockedNetwork.stubbedResponse = data
        mockedNetwork.stubbedStatusCode = statusCode
    }

    class TestXCSRequest: XCSRequest {

        var mockedNetwork = MockNetwork()
        var network: Network {
            return mockedNetwork
        }

        var didCreateRequest = false
        func createRequest(_ data: String) -> HTTPRequest {
            didCreateRequest = true
            return testRequest
        }

        var didParse = false
        func parse(response data: Data) -> Data? {
            didParse = true
            return data
        }
    }
}
