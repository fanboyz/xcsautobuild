//
// Created by Sean Henry on 16/09/2016.
//

import XCTest
@testable import xcsautobuild

class XCSResponseTests: XCTestCase {

    func test_isSuccess_shouldBeTrue_when2xx() {
        XCTAssert(response(withStatus: 200).isSuccess)
        XCTAssert(response(withStatus: 201).isSuccess)
        XCTAssert(response(withStatus: 299).isSuccess)
    }

    func test_isSuccess_shouldBeFalse_whenNot2xx() {
        XCTAssertFalse(response(withStatus: 300).isSuccess)
        XCTAssertFalse(response(withStatus: 199).isSuccess)
        XCTAssertFalse(response(withStatus: 404).isSuccess)
        XCTAssertFalse(response(withStatus: 500).isSuccess)
    }

    // MARK: - Helpers

    func response(withStatus status: Int) -> XCSResponse<Int> {
        return XCSResponse(data: 0, statusCode: status)
    }
}
