
import XCTest
@testable import xcsautobuild

class AnyXCSRequestTests: XCTestCase {
    
    var request: AnyXCSRequest<String, String>!
    var mockedRequest: MockXCSRequest<String, String>!
    
    override func setUp() {
        super.setUp()
        mockedRequest = MockXCSRequest()
        request = AnyXCSRequest(mockedRequest)
    }

    // MARK: - requestSender

    func test_requestSender() {
        XCTAssert(request.requestSender is MockHTTPRequestSender)
    }
    
    // MARK: - createRequest
    
    func test_createRequest() {
        createRequest()
        XCTAssert(mockedRequest.didCreateRequest)
    }

    // MARK: - parse

    func test_parse() {
        parse()
        XCTAssert(mockedRequest.didParse)
    }

    // MARK: - send

    func test_send() {
        request.send("") { _ in }
        XCTAssert(mockedRequest.didSend)
    }
    
    // MARK: - Helpers
    
    func createRequest() {
        _ = request.createRequest("")
    }
    
    func parse() {
        _ = request.parse(response: Data())
    }
}
