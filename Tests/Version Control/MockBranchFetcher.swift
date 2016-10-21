
import Foundation
@testable import xcsautobuild

class MockBranchFetcher: BranchFetcher {

    var stubbedBranches = [Branch]()
    var didFetchBranches = false
    func fetchBranches() -> [Branch] {
        didFetchBranches = true
        return stubbedBranches
    }
}
