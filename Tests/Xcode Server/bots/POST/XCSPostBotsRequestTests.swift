//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class XCSPostBotsRequestTests: XCTestCase {
    
    var request: XCSPostBotsRequest!
    
    override func setUp() {
        super.setUp()
        request = XCSPostBotsRequest(network: MockNetwork())
    }
    
    // MARK: - create

    func test_create_shouldSendNetworkRequest() {
        let expectedURL = testEndpoint + "bots"
        let request = self.request.createRequest([:])
        XCTAssertEqual(request.method, HTTPMethod.post)
        XCTAssertEqual(request.url, expectedURL)
    }

    // MARK: - parse

    func test_parse_shouldReturnVoid() {
        XCTAssertNotNil(request.parse(response: NSData()))
    }
}
