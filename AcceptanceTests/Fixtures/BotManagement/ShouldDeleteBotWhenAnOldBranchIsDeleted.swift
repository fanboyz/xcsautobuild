//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldDeleteBotWhenAnOldBranchIsDeleted)
class ShouldDeleteBotWhenAnOldBranchIsDeleted: DecisionTable, GitFixture {

    // MARK: - Input
    var oldBranches: String!
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }
    
    var oldBranchesArray: [String] {
        return commaSeparatedList(from: oldBranches)
    }

    var oldBranchNames: [String] {
        return oldBranchesArray.map({ Constants.convertToBotName(branchName: $0) })
    }

    var oldBranchIDs: [String] {
        return oldBranchesArray.enumerated().map { String($0.0) }
    }

    // MARK: - Output
    var numberOfDeletedBots: NSNumber!

    // MARK: - Test
    var gitBuilder: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!
    var network: MockNetwork!

    override func setUp() {
        numberOfDeletedBots = nil
        network = MockNetwork()
        network.stubGetBots(withNames: oldBranchNames, ids: oldBranchIDs)
        oldBranchesArray.forEach { network.expectDeleteBot(id: $0) }
        setUpGit(branches: branchesArray)
        let branchesDataStore = FileXCSBranchesDataStore(file: testDataStoreFile)
        oldBranchesArray.forEach { branchesDataStore.save(branch: XCSBranch(name: $0, botID: $0)) }
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: testLocalGitURL.path)!,
            botSynchroniser: testBotSynchroniser,
            branchFilter: TransparentBranchFilter(),
            branchesDataStore: branchesDataStore
        )
    }

    override func test() {
        interactor.execute()
        waitUntil(network.deleteBotCount != 0)
        numberOfDeletedBots = network.deleteBotCount as NSNumber
    }
}
