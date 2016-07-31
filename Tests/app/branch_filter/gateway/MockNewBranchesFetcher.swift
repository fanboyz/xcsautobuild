//
//  MockNewBranchesFetcher.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockBranchesDataStore: BranchesDataStore {

    var didLoad = false
    func load() {
        didLoad = true
    }

    var didGetNewBranches = false
    var stubbedNewBranches = [Branch]()
    func getNewBranches() -> [Branch] {
        didGetNewBranches = true
        return stubbedNewBranches
    }

    func getDeletedBranches() -> [Branch] {
        return []
    }

    var didCommit = false
    func commit() {
        didCommit = true
    }
}
