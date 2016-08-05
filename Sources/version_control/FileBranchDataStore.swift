//
//  FileBranchDataStore.swift
//
//
//

import Foundation

class FileBranchDataStore: BranchesDataStore {

    private(set) var branchNames = [String]()
    private let branchFetcher: BranchFetcher
    private let branchPersister: BranchPersister
    private var remoteBranchNames = [String]()

    init(branchFetcher: BranchFetcher, branchPersister: BranchPersister) {
        self.branchFetcher = branchFetcher
        self.branchPersister = branchPersister
    }

    func load() {
        remoteBranchNames = branchFetcher.getRemoteBranchNames()
        branchNames = branchPersister.load()
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
        branchPersister.save(branchNames)
    }
}
