//
//  BranchDataStore.swift
//
//
//

import Foundation

class BranchDataStore: NewBranchesFetcher {

    var branchNames = [String]()
    private let branchFetcher: BranchFetcher

    init(branchFetcher: BranchFetcher) {
        self.branchFetcher = branchFetcher
    }

    func fetchNewBranches(completion: ([Branch]) -> ()) {
        let remoteNames = branchFetcher.getRemoteBranchNames()
        let newBranches = remoteNames.filter { !branchNames.contains($0) }
        completion(newBranches.map { Branch(name: $0) })
    }

    func fetchDeletedBranches(completion: ([Branch] -> ())) {
        let remoteNames = branchFetcher.getRemoteBranchNames()
        let deletedBranches = branchNames.filter { !remoteNames.contains($0) }
        completion(deletedBranches.map { Branch(name: $0) } )
    }

    func commitBranches() {
        branchNames = branchFetcher.getRemoteBranchNames()
    }
}
