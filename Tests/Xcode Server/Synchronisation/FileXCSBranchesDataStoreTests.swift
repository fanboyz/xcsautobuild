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
        branch = branchWithNoBotID()
        save()
        XCTAssertEqual(load(), branch)
    }

    func test_save_shouldSaveBranchWithBotID() {
        branch = branch(withName: "master")
        save()
        XCTAssertEqual(load(), branch)
    }

    func test_save_shouldOverwriteBranch() {
        branch = branchWithNoBotID()
        save()
        branch = branch(withName: "master")
        save()
        XCTAssertEqual(load(), branch)
    }

    func test_save_shouldReturnNil_whenNoBranch() {
        branch = branch(withName: "develop")
        XCTAssertNil(load())
    }

    func test_save_shouldSaveAndLoadMultipleBranches() {
        branch = branch(withName: "develop")
        save()
        branch = branch(withName: "master")
        save()
        XCTAssertEqual(load(withName: "develop"), branch(withName: "develop"))
        XCTAssertEqual(load(withName: "master"), branch(withName: "master"))
    }

    // MARK: - Helpers

    func save() {
        store.save(branch: branch)
    }

    func load() -> XCSBranch? {
        return store.load(fromBranchName: branch.name)
    }

    func load(withName name: String) -> XCSBranch? {
        return store.load(fromBranchName: name)
    }

    func branchWithNoBotID() -> XCSBranch {
        return XCSBranch(name: "develop", botID: nil)
    }

    func branch(withName name: String) -> XCSBranch {
        return XCSBranch(name: name, botID: "123")
    }

    func deleteFile() {
        _ = try? NSFileManager.defaultManager().removeItemAtPath(file)
    }
}
