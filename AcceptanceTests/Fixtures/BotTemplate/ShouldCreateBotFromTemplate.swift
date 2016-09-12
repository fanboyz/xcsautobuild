//
// Created by Sean Henry on 09/09/2016.
//

import Foundation

@objc(ShouldCreateBotFromTemplate)
class ShouldCreateBotFromTemplate: NSObject, SlimDecisionTable {

    // MARK: - Output
    var createdBotFromTemplate: String!

    // MARK: - Test
    var network: MockNetwork!
    var git: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!
    let templateBotData = "{\"name\":\"xcsautobuild [develop]\"}".utf8Data

    func reset() {
        createdBotFromTemplate = nil
        network = nil
        git = nil
        interactor = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testDataStoreFile)
    }

    func execute() {
        setUp()
        interactor.execute()
        waitUntil(network.createBotCount != 0)
        createdBotFromTemplate = fitnesseString(from: network.invokedBotData == templateBotData)
    }

    func setUp() {
        FileBotTemplatePersister(file: Constants.templateFile).save(BotTemplate(name: "", data: templateBotData))
        network = MockNetwork()
        network.expectCreateBot()
        git = TwoRemoteGitBuilder()
        git.add(branch: "develop")
        let branchFetcher = GitBranchFetcher(directory: git.localURL.path!)!
        interactor = BotSyncingInteractor(branchFetcher: branchFetcher, botSynchroniser: botSynchroniser, branchFilter: TransparentBranchFilter(), branchesDataStore: MockXCSBranchesDataStore())
    }
}
