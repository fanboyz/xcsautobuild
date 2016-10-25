
import XCTest
@testable import xcsautobuild

class XCSConfigurationTests: XCTestCase {

    // MARK: - ==

    func test_shouldBeEqual_whenPropertiesAreEqual() {
        XCTAssert(isEqual())
    }

    func test_shouldNotBeEqual_whenHostsAreNotEqual() {
        XCTAssertFalse(isEqual(host: "different"))
    }

    func test_shouldNotBeEqual_whenUserNamesAreNotEqual() {
        XCTAssertFalse(isEqual(userName: "different"))
    }

    func test_shouldNotBeEqual_whenPasswordsAreNotEqual() {
        XCTAssertFalse(isEqual(password: "different"))
    }

    // MARK: - Helpers

    func isEqual(
            host: String = "host",
            userName: String = "username",
            password: String = "password"
    ) -> Bool {
        let configuration = XCSConfiguration(host: "host", userName: "username", password: "password")
        let other = XCSConfiguration(host: host, userName: userName, password: password)
        return configuration == other
    }
}
