//
// Created by Sean Henry on 20/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class XCSDuplicateBotRequestTests: XCTestCase {

    var request: XCSDuplicateBotRequest!

    override func setUp() {
        super.setUp()
        request = XCSDuplicateBotRequest(network: MockNetwork())
    }

    // MARK: - createRequest

    func test_createRequest_shouldSendNetworkRequest() {
        let id = "bot_id"
        let name = "Bot Name"
        let expectedURL = testEndpoint + "bots/\(id)/duplicate"
        let request = self.request.createRequest(DuplicateBotRequestData(id: id, name: name))
        XCTAssertEqual(request.method, HTTPMethod.post)
        XCTAssertEqual(request.url, expectedURL)
        XCTAssertEqual(request.jsonBody as NSDictionary?, ["name": name])
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
