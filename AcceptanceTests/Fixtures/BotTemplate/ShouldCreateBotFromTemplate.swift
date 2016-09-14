//
// Created by Sean Henry on 09/09/2016.
//

import Foundation

@objc(ShouldCreateBotFromTemplate)
class ShouldCreateBotFromTemplate: DecisionTable, GitFixture {

    // MARK: - Output
    var createdBotFromTemplate: String!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: TwoRemoteGitBuilder!
    var interactor: BotSyncingInteractor!
    let templateBotData = "{\"name\":\"xcsautobuild [develop]\"}".utf8Data

    override func setUp() {
        FileBotTemplatePersister(file: Constants.templateFile).save(BotTemplate(name: "", data: templateBotData))
        network = MockNetwork()
        network.expectCreateBot()
        setUpGit(branches: "develop")
        let branchFetcher = GitBranchFetcher(directory: testLocalGitURL.path!)!
        interactor = BotSyncingInteractor(branchFetcher: branchFetcher, botSynchroniser: testBotSynchroniser, branchFilter: TransparentBranchFilter(), branchesDataStore: MockXCSBranchesDataStore())
    }

    override func test() {
        setUp()
        interactor.execute()
        waitUntil(network.createBotCount != 0)
        createdBotFromTemplate = fitnesseString(from: network.invokedBotData == templateBotData)
    }
}
