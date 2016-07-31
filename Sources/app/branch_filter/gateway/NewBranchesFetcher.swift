//
//  NewBranchesFetcher.swift
//
//
//

import Foundation

protocol BranchesDataStore {
    func load()
    func getNewBranches() -> [Branch]
    func getDeletedBranches() -> [Branch]
    func commit()
}
