//
//  BranchDataStoreTests.swift
//
//
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
    
    // MARK: - getNewBranches

    func test_getNewBranches_shouldReturnEmptyArray_whenNoRemoteBranches() {
        XCTAssert(getNewBranches().isEmpty)
    }

    func test_getNewBranches_shouldReturnNewBranches_whenNewRemoteBranchesHaveBeenAdded() {
        loadBranchNames(testRemoteBranchNames)
        XCTAssertEqual(getNewBranches(), testRemoteBranches())
    }

    func test_getNewBranches_shouldReturnNewBranches_whenARemoteBranchMatchesASavedBranch() {
        commitBranchNames(["a"])
        loadBranchNames(["a", "b", "c"])
        XCTAssertEqual(getNewBranches(), [Branch(name: "b"), Branch(name: "c")])
    }

    func test_getNewBranches_shouldReturnEmptyArray_whenRemoteBranchesHaveNotChanged() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames(testRemoteBranchNames)
        XCTAssert(getNewBranches().isEmpty)
    }

    func test_getNewBranches_shouldReturnEmptyArray_whenRemoteBranchesHaveBeenDeleted() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames([])
        XCTAssert(getNewBranches().isEmpty)
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

    func test_newBranchesAndDeletedBranchesCanBeFetched() {
        commitBranchNames(testRemoteBranchNames)
        loadBranchNames(["a", "b", "d"])
        XCTAssertEqual(getNewBranches(), [Branch(name: "d")])
        XCTAssertEqual(getDeletedBranches(), [Branch(name: "c")])
    }

    // MARK: - Helpers

    func load() {
        store.load()
    }

    func getNewBranches() -> [Branch] {
        return store.getNewBranches()
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
