//
//  BranchDataStore.swift
//
//
//

import Foundation

class BranchDataStore: BranchesDataStore {

    var branchNames = [String]()
    private let branchFetcher: BranchFetcher
    private var remoteBranchNames = [String]()

    init(branchFetcher: BranchFetcher) {
        self.branchFetcher = branchFetcher
    }

    func load() {
        remoteBranchNames = branchFetcher.getRemoteBranchNames()
    }

    func getNewBranches() -> [Branch] {
        let newBranches = remoteBranchNames.filter { !branchNames.contains($0) }
        return newBranches.map { Branch(name: $0) }
    }

    func getDeletedBranches() -> [Branch] {
        let deletedBranches = branchNames.filter { !remoteBranchNames.contains($0) }
        return deletedBranches.map { Branch(name: $0) }
    }

    func commit() {
        branchNames = branchFetcher.getRemoteBranchNames()
    }
}
