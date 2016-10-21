
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
        return oldBranchesArray.map({ BotNameConverter.convertToBotName(branchName: $0) })
    }

    var oldBranchIDs: [String] {
        return oldBranchesArray.enumerated().map { String($0.0) }
    }

    // MARK: - Output
    var numberOfDeletedBots: NSNumber!

    // MARK: - Test
    var gitBuilder: GitBuilder!
    var interactor: BotSyncingInteractor!
    var network: MockNetwork!

    override func setUp() {
        numberOfDeletedBots = nil
        network = MockNetwork()
        network.stubGetBots(withNames: oldBranchNames, ids: oldBranchIDs)
        oldBranchesArray.forEach { network.expectDeleteBot(id: $0) }
        setUpGit(branches: branchesArray)
        let botDataStore = PlistBotDataStore(file: testDataStoreFile)
        oldBranchesArray.forEach { botDataStore.save(Bot(branchName: $0, id: $0)) }
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            botDataStore: botDataStore
        )
    }

    override func test() {
        interactor.execute()
        waitUntil(network.deleteBotCount != 0)
        numberOfDeletedBots = network.deleteBotCount as NSNumber
    }
}
