//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockXCSBranchesDataStore: XCSBranchesDataStore {

    var stubbedBranch: XCSBranch?
    func load(fromBranchName name: String) -> XCSBranch? {
        return stubbedBranch
    }

    func save(branch branch: XCSBranch) {
    }
}
