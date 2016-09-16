//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldAddABotWhenANewBranchIsFound)
class ShouldAddABotWhenANewBranchIsFound: DecisionTable, GitFixture {

    // MARK: - Input
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }

    // MARK: - Output
    var numberOfCreatedBots: NSNumber!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!

    override func setUp() {
        numberOfCreatedBots = nil
        network = MockNetwork()
        network.expectCreateBot()
        setUpGit(branches: branchesArray)
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: testLocalGitURL.path!)!,
            botSynchroniser: testBotSynchroniser,
            branchFilter: TransparentBranchFilter(),
            branchesDataStore: FileXCSBranchesDataStore(file: testDataStoreFile)
        )
    }

    override func test() {
        interactor.execute()
        waitUntil(network.createBotCount != 0)
        numberOfCreatedBots = network.createBotCount
    }
}
