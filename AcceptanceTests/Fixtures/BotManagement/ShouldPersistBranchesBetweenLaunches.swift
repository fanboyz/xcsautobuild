//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldPersistBranchesBetweenLaunches)
class ShouldPersistBranchesBetweenLaunches: NSObject, SlimDecisionTable {

    // MARK: - Input
    var savedBranches: String!
    var branches: String!
    var savedBranchesArray: [String]! {
        return commaSeparatedList(from: savedBranches)
    }
    var branchesArray: [String]! {
        return commaSeparatedList(from: branches)
    }
    var deletedBranchesIndicies: [String] {
        return savedBranchesArray.enumerate().flatMap { branchesArray.contains($0.1) ? nil : String($0.0) }
    }
    var savedBranchNames: [String] {
        return savedBranchesArray.map({ XcodeServerBotAPI.branchNameToBotName($0) })
    }
    var savedBranchIDs: [String] {
        return savedBranchesArray.enumerate().map { String($0.0) }
    }

    // MARK: - Output
    var numberOfCreatedBots: NSNumber!
    var numberOfDeletedBots: NSNumber!

    // MARK: - Test
    var network: MockNetwork!
    var git: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!

    func reset() {
        network = nil
        branches = nil
        savedBranches = nil
        numberOfDeletedBots = nil
        numberOfCreatedBots = nil
        git = nil
        interactor = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testDataStoreFile)
    }

    func execute() {
        setUp()
        interactor.execute()
        wait()
        numberOfCreatedBots = network.createBotCount
        numberOfDeletedBots = network.deleteBotCount
    }

    private func setUp() {
        network = MockNetwork()
        network.expectCreateBot()
        network.stubGetBots(withNames: savedBranchNames, ids: savedBranchIDs)
        deletedBranchesIndicies.forEach { network.expectDeleteBot(id: $0) }
        git = TwoRemoteGitBuilder()
        branchesArray.forEach { git.add(branch: $0) }
        let persister = FileBranchPersister(file: testDataStoreFile)
        persister.save(savedBranchesArray)
        let dataStore = FileBranchDataStore(branchFetcher: GitBranchFetcher(directory: git.localURL.path!)!, branchPersister: persister)
        interactor = BotSyncingInteractor(branchesDataStore: dataStore, botCreator: api, botDeleter: api, branchFilter: TransparentBranchFilter())
    }
}
