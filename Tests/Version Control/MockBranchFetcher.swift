//
//  MockBranchFetcher.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockBranchFetcher: BranchFetcher {

    var stubbedRemoteBranchNames = [String]()
    var didGetRemoteBranchNames = false
    func getRemoteBranchNames() -> [String] {
        didGetRemoteBranchNames = true
        return stubbedRemoteBranchNames
    }
}
