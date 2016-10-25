
import XCTest
@testable import xcsautobuild

class PlistXCSConfigurationDataStoreTests: XCTestCase {

    var store: PlistXCSConfigurationDataStore!
    let file = URL(fileURLWithPath: NSTemporaryDirectory() + "temp")
    let testXCSConfiguration = XCSConfiguration(host: "host", userName: "userName", password: "password")

    override func setUp() {
        super.setUp()
        removeFile()
        store = PlistXCSConfigurationDataStore(file: file)
    }

    override func tearDown() {
        removeFile()
        super.tearDown()
    }

    // MARK: - load

    func test_load_shouldReturnNil_whenNoSavedConfiguration() {
        XCTAssertNil(store.load())
    }

    func test_load_shouldReturnNil_whenSavedConfigurationIsInvalid() {
        writeInvalidFile()
        XCTAssertNil(store.load())
    }

    func test_load_shouldReturnSavedConfiguration() {
        store.save(testXCSConfiguration)
        XCTAssertEqual(store.load(), testXCSConfiguration)
    }

    // MARK: - Helpers

    func removeFile() {
        try? FileManager.default.removeItem(at: file)
    }

    func writeInvalidFile() {
        try! testData.write(to: file)
    }
}

