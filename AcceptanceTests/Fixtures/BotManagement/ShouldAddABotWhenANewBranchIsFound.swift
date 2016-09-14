//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldAddABotWhenANewBranchIsFound)
class ShouldAddABotWhenANewBranchIsFound: DecisionTable {

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

    override func setUp() {
        numberOfCreatedBots = nil
    }

        setUp()
        interactor.execute()
        waitUntil(network.createBotCount != 0)
        numberOfCreatedBots = network.createBotCount
    override func test() {
    }

    func setUp() {
        network = MockNetwork()
        network.expectCreateBot()
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(directory: git.localURL.path!)!, branchPersister: FileBranchPersister(file: testDataStoreFile))
        interactor = BotSyncingInteractor(branchesDataStore: dataStore, botCreator: api, botDeleter: api, branchFilter: TransparentBranchFilter())
    }
}
