//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class FileXCSBranchesDataStoreTests: XCTestCase {

    var store: FileXCSBranchesDataStore!
    var branch: XCSBranch!
    let file = NSTemporaryDirectory() + "TestXCSBranches"
    let develop = XCSBranch(name: "develop", botID: "master_bot_id")
    let master = XCSBranch(name: "master", botID: "develop_bot_id")
    let branchWithNoBotID = XCSBranch(name: "develop", botID: nil)

    override func setUp() {
        super.setUp()
        deleteFile()
        store = FileXCSBranchesDataStore(file: file)
    }

    override func tearDown() {
        deleteFile()
        super.tearDown()
    }

    // MARK: - save

    func test_save_shouldSaveBranchWithoutBotID() {
        let branch = branchWithNoBotID
        save(branch)
        XCTAssertEqual(load(branchNamed: branchWithNoBotID.name), branch)
    }

    func test_save_shouldSaveBranchWithBotID() {
        save(master)
        XCTAssertEqual(load(branchNamed: "master"), master)
    }

    func test_save_shouldOverwriteBranch() {
        save(XCSBranch(name: "master", botID: "different"))
        save(master)
        XCTAssertEqual(load(branchNamed: "master"), master)
    }

    func test_save_shouldReturnNil_whenNoBranch() {
        XCTAssertNil(load(branchNamed: "develop"))
    }

    func test_save_shouldSaveAndLoadMultipleBranches() {
        save(develop)
        save(master)
        XCTAssertEqual(load(branchNamed: "develop"), develop)
        XCTAssertEqual(load(branchNamed: "master"), master)
    }

    // MARK: - load

    func test_load_shouldLoadAllSavedBranches() {
        save(develop)
        save(master)
        let loaded = load()
        XCTAssert(loaded.contains(develop))
        XCTAssert(loaded.contains(master))
        XCTAssertEqual(loaded.count, 2)
    }

    func test_load_shouldIgnoreBadFile() {
        writeBadFile()
        XCTAssert(load().isEmpty)
    }

    // MARK: - Helpers

    func save(branch: XCSBranch? = nil) {
        store.save(branch: branch ?? self.branch)
    }

    func load() -> [XCSBranch] {
        return store.load()
    }

    func load(branchNamed name: String) -> XCSBranch? {
        return store.load(fromBranchName: name)
    }

    func deleteFile() {
        _ = try? NSFileManager.defaultManager().removeItemAtPath(file)
    }

    func writeBadFile() {
        try! "invalid!".writeToFile(file, atomically: true, encoding: NSUTF8StringEncoding)
    }
}
