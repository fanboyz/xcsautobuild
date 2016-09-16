//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockXCSBranchesDataStore: XCSBranchesDataStore {

    var didLoad = false
    var invokedBranchName: String?
    var stubbedBranch: XCSBranch?
    func load(fromBranchName name: String) -> XCSBranch? {
        didLoad = true
        invokedBranchName = name
        return stubbedBranch
    }

    var stubbedBranches = [XCSBranch]()
    func load() -> [XCSBranch] {
        didLoad = true
        return stubbedBranches
    }

    var invokedBranch: XCSBranch?
    func save(branch branch: XCSBranch) {
        invokedBranch = branch
    }
}
