//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class FileBranchDataStoreTests: XCTestCase {
    
    var store: FileBranchDataStore!
    var mockedBranchFetcher: MockBranchFetcher!
    var mockedBranchPersister: MockBranchPersister!
    let testRemoteBranchNames = ["a", "b", "c"]

    override func setUp() {
        super.setUp()
        mockedBranchFetcher = MockBranchFetcher()
        mockedBranchPersister = MockBranchPersister()
        store = FileBranchDataStore(branchFetcher: mockedBranchFetcher, branchPersister: mockedBranchPersister)
    }

    // MARK: - load

    func test_load_shouldFetchRemoteBranches() {
        load()
        XCTAssert(mockedBranchFetcher.didGetRemoteBranchNames)
    }

    func test_load_shouldLoadPersistedRemoteBranches() {
        load()
        XCTAssert(mockedBranchPersister.didLoad)
    }

    // MARK: - getAllBranches

    func test_getAllBranches_shouldReturnAllBranches() {
        loadBranchNames(testRemoteBranchNames)
        XCTAssertEqual(getAllBranches(), testRemoteBranches())
    }

    // MARK: - getDeletedBranches

    func test_getDeletedBranches_shouldReturnEmptyArray_whenNoPreviousBranches() {
        XCTAssert(getDeletedBranches().isEmpty)
    }

    func test_getDeletedBranches_shouldReturnBranch_whenRemoteBranchHasBeenRemoved() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames(["a", "b"])
        XCTAssertEqual(getDeletedBranches(), [Branch(name: "c")])
    }

    func test_getDeletedBranches_shouldReturnEmptyArray_whenRemoteBranchesHaveBeenAdded() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames(["a", "b", "c", "d"])
        XCTAssert(getDeletedBranches().isEmpty)
    }

    func test_getDeletedBranches_shouldReturnEmptyArray_whenRemoteBranchesHaveNotChanged() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames(testRemoteBranchNames)
        XCTAssert(getDeletedBranches().isEmpty)
    }

    // MARK: - commit

    func test_commit_shouldStoreRemoteBranchNamesLocally() {
        mockedBranchFetcher.stubbedRemoteBranchNames = testRemoteBranchNames
        store.commit()
        XCTAssertEqual(store.branchNames, testRemoteBranchNames)
    }

    func test_commit_shouldPersistRemoteBranchNames() {
        mockedBranchFetcher.stubbedRemoteBranchNames = testRemoteBranchNames
        store.commit()
        XCTAssertEqual(mockedBranchPersister.invokedSavedBranches!, testRemoteBranchNames)
    }

    // MARK: - Integration

    func test_deletedBranchesCanBeFetched() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames(["a", "b", "d"])
        XCTAssertEqual(getDeletedBranches(), [Branch(name: "c")])
    }

    // MARK: - Helpers

    func load() {
        store.load()
    }

    func getAllBranches() -> [Branch] {
        return store.getAllBranches()
    }
    func getDeletedBranches() -> [Branch] {
        return store.getDeletedBranches()
    }

    func testRemoteBranches() -> [Branch] {
        return testRemoteBranchNames.map { Branch(name: $0) }
    }

    func loadBranchNames(names: [String]) {
        mockedBranchFetcher.stubbedRemoteBranchNames = names
        load()
    }

    func commitBranchNames(names: [String]) {
        loadBranchNames(names)
        mockedBranchPersister.stubbedBranches = names
    }
}
