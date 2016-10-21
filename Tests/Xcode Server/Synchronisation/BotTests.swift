
import Foundation
import XCTest
@testable import xcsautobuild

class BotTests: XCTestCase {

    // MARK: - ==

    func test_shouldBeEqual_whenPropertiesAreEqual() {
        XCTAssert(isEqual())
    }

    func test_shouldNotBeEqual_whenBranchNamesAreNotEqual() {
        XCTAssertFalse(isEqual(name: "different"))
    }

    func test_shouldNotBeEqual_whenIDsAreNotEqual() {
        XCTAssertFalse(isEqual(id: "different"))
    }

    // MARK: - Helpers

    func isEqual(
            name: String = "name",
            id: String = "botID"
    ) -> Bool {
        let bot = Bot(branchName: "name", id: "botID")
        let other = Bot(branchName: name, id: id)
        return bot == other
    }
}
