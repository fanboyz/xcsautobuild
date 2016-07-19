//
//  BranchDataStoreTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class BranchDataStoreTests: XCTestCase {
    
    var store: BranchDataStore!
    var mockedBranchFetcher: MockBranchFetcher!
    let stubbedRemoteBranchNames = ["a", "b", "c"]

    override func setUp() {
        super.setUp()
        mockedBranchFetcher = MockBranchFetcher()
        store = BranchDataStore(branchFetcher: mockedBranchFetcher)
    }
    
    // MARK: - fetchNewBranches
    
    func test_fetchNewBranches_shouldFetchRemoteBranches() {
        fetchNewBranches()
        XCTAssert(mockedBranchFetcher.didGetRemoteBranchNames)
    }

    func test_fetchNewBranches_shouldReturnNewBranches_whenNoBranchesHaveBeenSaved() {
        mockedBranchFetcher.stubbedRemoteBranchNames = stubbedRemoteBranchNames
        XCTAssertEqual(fetchNewBranches(), stubbedRemoteBranches())
    }

    func test_fetchNewBranches_shouldReturnEmptyArray_whenNoRemoteBranches() {
        XCTAssert(fetchNewBranches().isEmpty)
    }

    func test_fetchNewBranches_shouldReturnBranch_whenRemoteBranchMatchesSavedBranch() {
        mockedBranchFetcher.stubbedRemoteBranchNames = ["a"]
        commitBranches()
        mockedBranchFetcher.stubbedRemoteBranchNames = stubbedRemoteBranchNames
        XCTAssertEqual(fetchNewBranches(), [Branch(name: "b"), Branch(name: "c")])
    }

    // MARK: - fetchDeletedBranches

    func test_fetchDeletedBranches_shouldReturnEmptyArray_whenNoPreviousBranches() {
        XCTAssert(fetchDeletedBranches().isEmpty)
    }

    func test_fetchDeletedBranches_shouldReturnBranch_whenRemoteBranchHasBeenRemoved() {
        mockedBranchFetcher.stubbedRemoteBranchNames = stubbedRemoteBranchNames
        commitBranches()
        mockedBranchFetcher.stubbedRemoteBranchNames = ["a", "b"]
        XCTAssertEqual(fetchDeletedBranches(), [Branch(name: "c")])
    }

    // MARK: - commitBranches

    func test_commitBranches_shouldStoreRemoteBranchNames() {
        mockedBranchFetcher.stubbedRemoteBranchNames = stubbedRemoteBranchNames
        commitBranches()
        XCTAssertEqual(store.branchNames, stubbedRemoteBranchNames)
    }

    // MARK: - Helpers

    func fetchNewBranches() -> [Branch]! {
        var branches: [Branch]!
        store.fetchNewBranches { b in
            branches = b
        }
        return branches
    }

    func fetchDeletedBranches() -> [Branch]! {
        var branches: [Branch]!
        store.fetchDeletedBranches { b in
            branches = b
        }
        return branches
    }

    func commitBranches() {
        store.commitBranches()
    }

    func stubbedRemoteBranches() -> [Branch] {
        return stubbedRemoteBranchNames.map { Branch(name: $0) }
    }
}
