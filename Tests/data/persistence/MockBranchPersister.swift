//
//  MockBranchPersister.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockBranchPersister: BranchPersister {

    var didLoad = false
    var stubbedBranches = [String]()
    func load() -> [String] {
        didLoad = true
        return stubbedBranches
    }

    var invokedSavedBranches: [String]?
    func save(branches: [String]) {
        invokedSavedBranches = branches
    }
}
