//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldPersistBranchesBetweenLaunches)
class ShouldPersistBranchesBetweenLaunches: DecisionTable, GitFixture {

    // MARK: - Input
    var savedBranches: String!
    var branches: String!
    var savedBranchesArray: [String]! {
        return commaSeparatedList(from: savedBranches)
    }

    var branchesArray: [String]! {
        return commaSeparatedList(from: branches)
    }

    var savedBranchNames: [String] {
        return savedBranchesArray.map({ Constants.convertBranchNameToBotName($0) })
    }

    var savedBranchIDs: [String] {
        return savedBranchesArray.enumerate().map { String($0.0) }
    }

    // MARK: - Output
    var numberOfCreatedBots: NSNumber!
    var numberOfDeletedBots: NSNumber!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!

    override func setUp() {
        numberOfDeletedBots = nil
        numberOfCreatedBots = nil
        network = MockNetwork()
        network.expectCreateBot()
        network.stubGetBots(withNames: savedBranchNames, ids: savedBranchIDs)
        savedBranchesArray.forEach { network.expectDeleteBot(id: $0) }
        setUpGit(branches: branchesArray)
        let branchesDataStore = FileXCSBranchesDataStore(file: testDataStoreFile)
        savedBranchesArray.forEach { branchesDataStore.save(branch: XCSBranch(name: $0, botID: $0)) }
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: testLocalGitURL.path!)!,
            botSynchroniser: testBotSynchroniser,
            branchFilter: TransparentBranchFilter(),
            branchesDataStore: branchesDataStore
        )
    }

    override func test() {
        interactor.execute()
        wait()
        numberOfCreatedBots = network.createBotCount
        numberOfDeletedBots = network.deleteBotCount
    }
}
