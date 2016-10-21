
import Foundation
@testable import xcsautobuild

class MockBranchFilter: BranchFilter {

    var didFilterBranches = false
    var invokedBranches: [Branch]?
    var stubbedFilteredBranches = [Branch]()
    func filter(_ branches: [Branch]) -> [Branch] {
        didFilterBranches = true
        invokedBranches = branches
        return stubbedFilteredBranches
    }
}
