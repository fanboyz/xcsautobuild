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
        return savedBranchesArray.map({ BotNameConverter.convertToBotName(branchName: $0) })
    }

    var savedBranchIDs: [String] {
        return savedBranchesArray.enumerated().map { String($0.0) }
    }

    // MARK: - Output
    var numberOfCreatedBots: NSNumber!
    var numberOfDeletedBots: NSNumber!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: GitBuilder!
    var interactor: BotSyncingInteractor!

    override func setUp() {
        numberOfDeletedBots = nil
        numberOfCreatedBots = nil
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
        network = MockNetwork()
        network.expectDuplicateBot(id: testTemplateBotID)
        network.stubGetBots(withNames: savedBranchNames, ids: savedBranchIDs)
        savedBranchesArray.forEach { network.expectDeleteBot(id: $0) }
        setUpGit(branches: branchesArray)
        let botDataStore = FileBotDataStore(file: testDataStoreFile)
        savedBranchesArray.forEach { botDataStore.save(Bot(branchName: $0, id: $0)) }
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            botDataStore: botDataStore
        )
    }

    override func test() {
        interactor.execute()
        wait(for: 0.05)
        numberOfCreatedBots = network.duplicateBotCount as NSNumber
        numberOfDeletedBots = network.deleteBotCount as NSNumber
    }
}
