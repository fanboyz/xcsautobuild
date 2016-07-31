//
//  XCSGetBotsResponseParserTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class XCSGetBotsResponseParserTests: XCTestCase {
    
    var parser: XCSGetBotsResponseParser!
    var response: NSData!
    
    override func setUp() {
        super.setUp()
        parser = XCSGetBotsResponseParser()
    }

    // MARK: - parse

    func test_parse_shouldReturnEmptyArray_whenNoBots() {
        stubArrayResponse([])
        XCTAssert(parse().isEmpty)
    }

    func test_parse_shouldReturnBot_whenValidBot() {
        stubArrayResponse([["_id": "123", "name": "my bot"]])
        XCTAssertEqual(parse().count, 1)
    }

    func test_parse_shouldReturnBots_whenValidBots() {
        stubArrayResponse([["_id": "123", "name": "my bot"], ["_id": "456", "name": "my bot 2"]])
        XCTAssertEqual(parse().count, 2)
    }

    func test_parse_shouldReturnEmptyArray_whenInvalidBots() {
        stubArrayResponse([["not valid": "123", "name": "bot"]])
        XCTAssert(parse().isEmpty)
        stubArrayResponse([["_id": "123", "not valid": "bot"]])
        XCTAssert(parse().isEmpty)
    }

    // MARK: - Helpers

    func parse() -> [RemoteBot] {
        return parser.parse(response: response)
    }

    func stubArrayResponse(array: [AnyObject]) {
        let object = ["results": array]
        let data = try! NSJSONSerialization.dataWithJSONObject(object, options: [])
        response = data
    }
}
