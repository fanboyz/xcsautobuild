//
//  Copyright (c) 2016 Sean Henry
//

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
