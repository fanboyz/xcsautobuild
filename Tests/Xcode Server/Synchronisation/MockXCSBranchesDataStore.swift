//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockXCSBranchesDataStore: XCSBranchesDataStore {

    var didLoad = false
    var invokedLoadedBranchName: String?
    var stubbedLoadedBranch: XCSBranch?
    func load(fromBranchName name: String) -> XCSBranch? {
        didLoad = true
        invokedLoadedBranchName = name
        return stubbedLoadedBranch
    }

    var stubbedLoadedBranches = [XCSBranch]()
    func load() -> [XCSBranch] {
        didLoad = true
        return stubbedLoadedBranches
    }

    var invokedSavedBranch: XCSBranch?
    func save(_ branch: XCSBranch) {
        invokedSavedBranch = branch
    }

    var didDelete = false
    var invokedDeletedBranch: XCSBranch?
    func delete(_ branch: XCSBranch) {
        didDelete = true
        invokedDeletedBranch = branch
    }
}
