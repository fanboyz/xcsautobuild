//
//  ShouldAddABotWhenANewBranchIsFound.swift
//
//
//

import Foundation

@objc(ShouldAddABotWhenANewBranchIsFound)
class ShouldAddABotWhenANewBranchIsFound: NSObject, SlimDecisionTable {

    var branches: String!
    var numberOfCreatedBots: NSNumber!

    var branchesArray: [String]! {
        return commaSeparatedList(from: branches)
    }

    var git: TwoRemoteGitBuilder!
    var mockedBotCreator: MockBotCreator!
    var interactor: BranchSyncingInteractor!

    var testDataStoreFile: String {
        return NSTemporaryDirectory() + "data_store"
    }

    func reset() {
        branches = nil
        numberOfCreatedBots = nil
        git = nil
        mockedBotCreator = nil
        interactor = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testDataStoreFile)
    }

    func execute() {
        setUp()
        interactor.execute()
        numberOfCreatedBots = mockedBotCreator.invokedBranches.count
    }

    private func setUp() {
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        mockedBotCreator = MockBotCreator()
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(commandLine: CommandLine(directory: git.localURL.path!)), branchPersister: FileBranchPersister(file: testDataStoreFile))
        interactor = BranchSyncingInteractor(branchesDataStore: dataStore, botCreator: mockedBotCreator, botDeleter: MockBotDeleter())
    }
}
