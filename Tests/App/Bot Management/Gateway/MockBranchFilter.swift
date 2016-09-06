//
// Created by Sean Henry on 06/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockBranchFilter: BranchFilter {

    var didFilterBranches = false
    var invokedBranches: [Branch]?
    var stubbedFilteredBranches = [Branch]()
    func filterBranches(branches: [Branch]) -> [Branch] {
        didFilterBranches = true
        invokedBranches = branches
        return stubbedFilteredBranches
    }
}
