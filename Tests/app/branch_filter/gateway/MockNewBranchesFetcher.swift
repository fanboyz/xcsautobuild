//
//  MockNewBranchesFetcher.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockNewBranchesFetcher: NewBranchesFetcher {

    var didFetchNewBranches = false
    var stubbedBranches = [Branch]()
    func fetchNewBranches(completion: ([Branch]) -> ()) {
        didFetchNewBranches = true
        completion(stubbedBranches)
    }
}
