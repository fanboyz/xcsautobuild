
import Foundation

import XCTest
@testable import xcsautobuild

class FilePatternDataStoreTests: XCTestCase {

    var store: FilePatternDataStore!
    let file = NSTemporaryDirectory() + "/pattern"

    override func setUp() {
        super.setUp()
        removeFile()
        store = FilePatternDataStore(file: file)
    }

    override func tearDown() {
        removeFile()
        super.tearDown()
    }

    // MARK: - save

    func test_save_shouldSavePattern() {
        let pattern = "feature/*"
        store.save(pattern)
        store = FilePatternDataStore(file: file);
        XCTAssertEqual(store.load(), pattern)
    }

    func test_save_shouldOverwritePattern() {
        store.save("feature/*")
        let pattern = "release/*"
        store.save(pattern)
        store = FilePatternDataStore(file: file);
        XCTAssertEqual(store.load(), pattern)
    }

    // MARK: - Helpers

    func removeFile() {
        try? FileManager.default.removeItem(atPath: file)
    }
}
