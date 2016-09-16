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

    func test_parse_shouldReturnBotID() {
        let json = FlexiJSON(jsonString: "{ \"_id\": \"bot_id\"}")
        XCTAssertEqual(request.parse(response: json.data!), "bot_id")
    }

    func test_parse_shouldReturnNil_whenCannotParseData() {
        XCTAssertNil(request.parse(response: testData))
    }
}
