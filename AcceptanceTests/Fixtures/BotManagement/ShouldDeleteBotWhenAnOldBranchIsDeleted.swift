//
//  ShouldDeleteBotWhenAnOldBranchIsDeleted.swift
//
//
//

import Foundation

@objc(ShouldDeleteBotWhenAnOldBranchIsDeleted)
class ShouldDeleteBotWhenAnOldBranchIsDeleted: NSObject, SlimDecisionTable {

    var oldBranches: String!
    var branches: String!
    var numberOfDeletedBots: NSNumber!

    var branchesArray: [String]! {
        return commaSeparatedList(from: branches)
    }
    
    var oldBranchesArray: [String]! {
        return commaSeparatedList(from: oldBranches)
    }

    var git: TwoRemoteGitBuilder!
    var mockedBotDeleter: MockBotDeleter!
    var interactor: BranchSyncingInteractor!

    var testDataStoreFile: String {
        return NSTemporaryDirectory() + "data_store"
    }

    func reset() {
        branches = nil
        numberOfDeletedBots = nil
        git = nil
        mockedBotDeleter = nil
        interactor = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testDataStoreFile)
    }

    func execute() {
        setUp()
        interactor.execute()
        numberOfDeletedBots = mockedBotDeleter.invokedBranches.count
    }

    private func setUp() {
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        mockedBotDeleter = MockBotDeleter()
        let persister = FileBranchPersister(file: testDataStoreFile)
        persister.save(oldBranchesArray)
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(directory: git.localURL.path!)!, branchPersister: persister)
        interactor = BranchSyncingInteractor(branchesDataStore: dataStore, botCreator: MockBotCreator(), botDeleter: mockedBotDeleter)
    }
}
