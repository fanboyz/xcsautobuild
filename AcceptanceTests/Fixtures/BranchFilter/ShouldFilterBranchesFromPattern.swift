
import Foundation

@objc(ShouldFilterBranchesFromPattern)
class ShouldFilterBranchesFromPattern: DecisionTable {

    // MARK: - Input
    var pattern: String!
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }

    // MARK: - Output
    var createdBots: String!

    // MARK: - Test
    var network: MockNetwork!
    var git: GitBuilder!
    var interactor: BotSyncingInteractor!

    override func setUp() {
        createdBots = nil
    }

    override func test() {
        let branchFetcher = MockBranchFetcher()
        let mockedBotSynchroniser = MockBotSynchroniser()
        branchFetcher.stubbedBranches = branchesArray.map { Branch(name: $0) }
        let patternDataStore = FilePatternDataStore(file: testFilterPatternFile)
        patternDataStore.save(pattern: pattern.components(separatedBy: ",").joined(separator: "\n"))
        let filter = WildcardBranchFilter(patternDataStore: patternDataStore)
        let interactor = BotSyncingInteractor(branchFetcher: branchFetcher, botSynchroniser: mockedBotSynchroniser, branchFilter: filter, botDataStore: MockBotDataStore())
        interactor.execute()
        createdBots = commaSeparatedString(from: mockedBotSynchroniser.invokedSynchronisedBots.map { $0.branchName })
    }
}
