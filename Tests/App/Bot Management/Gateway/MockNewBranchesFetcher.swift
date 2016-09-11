//
//  Copyright (c) 2016 Sean Henry
//

@testable import xcsautobuild

class MockBranchesDataStore: BranchesDataStore {

    var didLoad = false
    func load() {
        didLoad = true
    }

    var didGetAllBranches = false
    var stubbedAllBranches = [Branch]()
    func getAllBranches() -> [Branch] {
        didGetAllBranches = true
        return stubbedAllBranches
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
