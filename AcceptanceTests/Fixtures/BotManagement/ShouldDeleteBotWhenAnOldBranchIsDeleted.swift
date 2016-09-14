//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldDeleteBotWhenAnOldBranchIsDeleted)
class ShouldDeleteBotWhenAnOldBranchIsDeleted: DecisionTable {

    // MARK: - Input
    var oldBranches: String!
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }
    var oldBranchesArray: [String] {
        return commaSeparatedList(from: oldBranches)
    }
    var deletedBranchesIndicies: [String] {
        return oldBranchesArray.enumerate().flatMap { branchesArray.contains($0.1) ? nil : String($0.0) }
    }
    var oldBranchNames: [String] {
        return oldBranchesArray.map({ Constants.convertBranchNameToBotName($0) })
    }
    var oldBranchIDs: [String] {
        return oldBranchesArray.enumerate().map { String($0.0) }
    }

    // MARK: - Output
    var numberOfDeletedBots: NSNumber!

    // MARK: - Test
    var git: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!
    var network: MockNetwork!

    override func setUp() {
        numberOfDeletedBots = nil
    }

        setUp()
        interactor.execute()
        waitUntil(network.deleteBotCount != 0)
        numberOfDeletedBots = network.deleteBotCount
    }

    private func setUp() {
        network = MockNetwork()
        network.stubGetBots(withNames: oldBranchNames, ids: oldBranchIDs)
        deletedBranchesIndicies.forEach { network.expectDeleteBot(id: $0) }
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        let persister = FileBranchPersister(file: testDataStoreFile)
        persister.save(oldBranchesArray)
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(directory: git.localURL.path!)!, branchPersister: persister)
        interactor = BotSyncingInteractor(branchesDataStore: dataStore, botCreator: api, botDeleter: api, branchFilter: TransparentBranchFilter())
    }
    override func test() {
}
