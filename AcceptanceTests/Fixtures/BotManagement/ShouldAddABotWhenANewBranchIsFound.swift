//
//  ShouldAddABotWhenANewBranchIsFound.swift
//
//
//

import Foundation

@objc(ShouldAddABotWhenANewBranchIsFound)
class ShouldAddABotWhenANewBranchIsFound: NSObject, SlimDecisionTable {

    // MARK: - Input
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }

    // MARK: - Output
    var numberOfCreatedBots: NSNumber!

    // MARK: - Test
    var network: MockNetwork!
    var git: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!

    func reset() {
        branches = nil
        numberOfCreatedBots = nil
        git = nil
        interactor = nil
        network = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testDataStoreFile)
    }

    func execute() {
        setUp()
        interactor.execute()
        waitUntil(network.createBotCount != 0)
        numberOfCreatedBots = network.createBotCount
    }

    func setUp() {
        network = MockNetwork()
        network.expectCreateBot()
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(directory: git.localURL.path!)!, branchPersister: FileBranchPersister(file: testDataStoreFile))
        interactor = BotSyncingInteractor(branchesDataStore: dataStore, botCreator: api, botDeleter: api)
    }
}
