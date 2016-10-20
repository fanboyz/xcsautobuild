//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class HTTPRequestTests: XCTestCase {
    
    // MARK: - ==

    func test_equals_shouldNotBeEqual_whenURLsAreDifferent() {
        XCTAssertFalse(isEqual(url: "bad url"))
    }

    func test_equals_shouldNotBeEqual_whenMethodsAreDifferent() {
        XCTAssertFalse(isEqual(method: .get))
    }

    func test_equals_shouldNotBeEqual_whenJSONBodyAreDifferent() {
        XCTAssertFalse(isEqual(jsonBody: ["not": "there"]))
    }

    func test_equals_shouldBeEqual() {
        XCTAssert(isEqual())
    }

    // MARK: - Helpers

    func isEqual(url: String = "url", method: HTTPMethod = .post, jsonBody: [String: Any] = ["key": "value"]) -> Bool {
        let request = HTTPRequest(path: url, method: method, jsonBody: jsonBody)
        let other = HTTPRequest(path: "url", method: .post, jsonBody: ["key": "value"])
        return request == other
    }
}
