//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

@objc(ShouldFilterBranchesFromPattern)
class ShouldFilterBranchesFromPattern: NSObject, SlimDecisionTable {

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
    var git: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!

    func reset() {
        pattern = nil
        createdBots = nil
    }

    func execute() {
        let dataStore = MockBranchesDataStore()
        let mockedBotCreator = MockBotCreator()
        dataStore.stubbedNewBranches = branchesArray.map { Branch(name: $0) }
        let filter = WildcardBranchFilter()
        filter.pattern = pattern
        let interactor = BotSyncingInteractor(branchesDataStore: dataStore, botCreator: mockedBotCreator, botDeleter: MockBotDeleter(), branchFilter: filter)
        interactor.execute()
        createdBots = commaSeparatedString(from: mockedBotCreator.invokedBranches.map { $0.name })
    }
}
