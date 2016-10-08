//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class XCSDeleteBotRequestTests: XCTestCase {
    
    var request: XCSDeleteBotRequest!
    
    override func setUp() {
        super.setUp()
        request = XCSDeleteBotRequest(network: MockNetwork())
    }
    
    // MARK: - createRequest
    
    func test_createRequest() {
        let request = self.request.createRequest("123")
        XCTAssertEqual(request.url, self.request.endpoint + "bots/123")
        XCTAssertEqual(request.method, HTTPMethod.delete)
        XCTAssertNil(request.jsonBody)
    }

    // MARK: - parse

    func test_parse() {
        XCTAssertNotNil(request.parse(response: Data()))
    }
}
