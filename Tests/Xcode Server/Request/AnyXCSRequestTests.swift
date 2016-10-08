//
//  Copyright (c) 2016 Sean Henry
//

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

    // MARK: - network

    func test_network() {
        XCTAssert(request.network is MockNetwork)
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
