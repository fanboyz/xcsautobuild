//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class XCSBranchTests: XCTestCase {

    // MARK: - ==

    func test_shouldBeEqual_whenPropertiesAreEqual() {
        XCTAssert(isEqual())
    }

    func test_shouldNotBeEqual_whenNamesAreNotEqual() {
        XCTAssertFalse(isEqual(name: "different"))
    }

    func test_shouldNotBeEqual_whenBotIDsAreNotEqual() {
        XCTAssertFalse(isEqual(botID: "different"))
    }

    // MARK: - Helpers

    func isEqual(
            name name: String = "name",
            botID: String = "botID"
    ) -> Bool {
        let branch = XCSBranch(name: "name", botID: "botID")
        let other = XCSBranch(name: name, botID: botID)
        return branch == other
    }
}
