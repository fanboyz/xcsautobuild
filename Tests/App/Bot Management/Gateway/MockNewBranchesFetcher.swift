//
//  MockNewBranchesFetcher.swift
//
//
//

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

    var didGetDeletedBranches = false
    var stubbedDeletedBranches = [Branch]()
    func getDeletedBranches() -> [Branch] {
        didGetDeletedBranches = true
        return stubbedDeletedBranches
    }

    var didCommit = false
    func commit() {
        didCommit = true
    }
}
