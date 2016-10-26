
import Foundation
import XCTest
@testable import xcsautobuild

class PlistGitConfigurationDataStoreTests: XCTestCase {

    var store: PlistGitConfigurationDataStore!
    let file = URL(fileURLWithPath: NSTemporaryDirectory() + "gitConfigurationDataStore")

    override func setUp() {
        super.setUp()
        removeFile()
        store = PlistGitConfigurationDataStore(file: file)
    }

    override func tearDown() {
        removeFile()
        super.tearDown()
    }

    // MARK: - load

    func test_load_shouldReturnNil_whenNoSavedData() {
        XCTAssertNil(store.load())
    }

    func test_load_shouldReturnNil_whenInvalidFile() {
        let invalidDictionary = ["http": ["invalid": ""]] as NSDictionary
        invalidDictionary.write(to: file, atomically: true)
        XCTAssertNil(store.load())
    }

    func test_load_shouldReturnSavedObject() {
        store.save(testGitConfiguration)
        XCTAssertEqual(store.load(), testGitConfiguration)
        store.save(testSSHGitConfiguration)
        XCTAssertEqual(store.load(), testSSHGitConfiguration)
    }

    // MARK: - Helpers

    func removeFile() {
        try? FileManager.default.removeItem(at: file)
    }
}

