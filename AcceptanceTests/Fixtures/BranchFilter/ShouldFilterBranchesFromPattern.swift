//
// Created by Sean Henry on 06/09/2016.
//

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
        let filter = WildcardBranchFilter()
        filter.pattern = pattern
        let interactor = BotSyncingInteractor(branchFetcher: branchFetcher, botSynchroniser: mockedBotSynchroniser, branchFilter: filter, branchesDataStore: MockXCSBranchesDataStore())
        interactor.execute()
        createdBots = commaSeparatedString(from: mockedBotSynchroniser.invokedSynchronisedBranches.map { $0.name })
    }
}
