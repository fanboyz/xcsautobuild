//
//  AnyXCSRequestTests.swift
//
//
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
    
    // MARK: - createRequest
    
    func test_createRequest() {
        request.createRequest("")
        XCTAssert(mockedRequest.didCreateRequest)
    }

    // MARK: - parse

    func test_parse() {
        request.parse(response: NSData())
        XCTAssert(mockedRequest.didParse)
    }

    // MARK: - send

    func test_send() {
        request.send("") { _ in }
        XCTAssert(mockedRequest.didSend)
    }
}
