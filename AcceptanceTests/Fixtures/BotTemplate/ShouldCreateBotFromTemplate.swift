//
// Created by Sean Henry on 09/09/2016.
//

import Foundation
import FlexiJSON

@objc(ShouldCreateBotFromTemplate)
class ShouldCreateBotFromTemplate: DecisionTable, GitFixture {

    // MARK: - Output
    var createdBotFromTemplate: String!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: GitBuilder!
    var interactor: BotSyncingInteractor!
    let templateBotData = "{\"name\":\"xcsautobuild [develop]\"}".utf8Data

    override func setUp() {
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
        network = MockNetwork()
        network.expectDuplicateBot(id: testTemplateBotID)
        setUpGit(branches: "develop")
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            branchesDataStore: MockXCSBranchesDataStore()
        )
    }

    override func test() {
        setUp()
        interactor.execute()
        waitUntil(network.duplicateBotCount != 0)
        let expectedBody = ["name": BotNameConverter.convertToBotName(branchName: "develop")]
        let expectedData = FlexiJSON(dictionary: expectedBody).data!
        createdBotFromTemplate = fitnesseString(from: network.invokedDuplicateBotResponse == expectedData)
    }
}
