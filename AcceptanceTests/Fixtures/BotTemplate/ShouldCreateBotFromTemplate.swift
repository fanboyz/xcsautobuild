
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
    var templateBotData: Data {
        return "{\"name\":\"xcsautobuild [\(newBranch)]\"}".utf8Data
    }

    override func setUp() {
        FileBotTemplateDataStore(file: testTemplateFile).save(testBotTemplate)
        network = MockNetwork()
        network.expectDuplicateBot(id: testTemplateBotID)
        network.stubGetBot(withID: testBotID, name: BotNameConverter.convertToBotName(branchName: newBranch))
        network.expectPatchBot(id: testBotID)
        setUpGit(branches: newBranch)
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            botDataStore: MockBotDataStore()
        )
    }

    override func test() {
        interactor.execute()
        waitUntil(network.duplicateBotCount != 0)
        waitUntil(network.patchedBotBranchName != nil)
        let expectedBody = ["name": BotNameConverter.convertToBotName(branchName: newBranch)]
        let expectedData = FlexiJSON(dictionary: expectedBody).data!
        createdBotFromTemplate = fitnesseString(from: network.invokedDuplicateBotResponse == expectedData)
        newBotBranch = network.patchedBotBranchName
    }
}
