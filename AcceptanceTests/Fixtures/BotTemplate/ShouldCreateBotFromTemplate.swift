//
// Created by Sean Henry on 09/09/2016.
//

import Foundation
import FlexiJSON

@objc(ShouldCreateBotFromTemplate)
class ShouldCreateBotFromTemplate: DecisionTable, GitFixture {

    // MARK: - Input
    var newBranch: String!

    // MARK: - Output
    var createdBotFromTemplate: String!
    var newBotBranch: String!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: GitBuilder!
    var interactor: BotSyncingInteractor!
    let templateBotData = "{\"name\":\"xcsautobuild [develop]\"}".utf8Data

    override func setUp() {
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
        network = MockNetwork()
        network.expectDuplicateBot(id: testTemplateBotID)
        network.expectPatchBot(id: testBotID)
        setUpGit(branches: "develop")
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            branchesDataStore: MockXCSBranchesDataStore()
        )
    }

    override func test() {
        interactor.execute()
        waitUntil(network.duplicateBotCount != 0)
        waitUntil(network.patchedBotBranchName != nil)
        let expectedBody = ["name": BotNameConverter.convertToBotName(branchName: "develop")]
        let expectedData = FlexiJSON(dictionary: expectedBody).data!
        createdBotFromTemplate = fitnesseString(from: network.invokedDuplicateBotResponse == expectedData)
        newBotBranch = network.patchedBotBranchName
    }
}
