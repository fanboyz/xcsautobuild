//
//  ShouldPersistBranchesBetweenLaunches.swift
//
//
//

import Foundation

@objc(ShouldPersistBranchesBetweenLaunches)
class ShouldPersistBranchesBetweenLaunches: NSObject, SlimDecisionTable {

    var savedBranches: String!
    var branches: String!
    var numberOfCreatedBots: NSNumber!
    var numberOfDeletedBots: NSNumber!

    var savedBranchesArray: [String]! {
        return commaSeparatedList(from: savedBranches)
    }

    var branchesArray: [String]! {
        return commaSeparatedList(from: branches)
    }

    var git: TwoRemoteGitBuilder!
    var mockedBotDeleter: MockBotDeleter!
    var mockedBotCreator: MockBotCreator!
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
        numberOfCreatedBots = mockedBotCreator.invokedBranches.count
        numberOfDeletedBots = mockedBotDeleter.invokedBranches.count
    }

    private func setUp() {
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        mockedBotCreator = MockBotCreator()
        mockedBotDeleter = MockBotDeleter()
        let persister = FileBranchPersister(file: testDataStoreFile)
        persister.save(savedBranchesArray)
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(directory: git.localURL.path!)!, branchPersister: persister)
        interactor = BranchSyncingInteractor(branchesDataStore: dataStore, botCreator: mockedBotCreator, botDeleter: mockedBotDeleter)
    }
}
