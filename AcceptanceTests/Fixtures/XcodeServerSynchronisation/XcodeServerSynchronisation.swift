
import Foundation

class XcodeServerSynchronisation: DecisionTable, GitFixture {

    // MARK: - Input
    var existingBotID: String!
    var botID: String? {
        return existingBotID != "" ? existingBotID : nil
    }

    // MARK: - Test
    let validBotID = "valid_bot_id"
    let invalidBotID = "invalid_bot_id"
    let newBotID = "new_bot_id"
    let branch = "develop"
    var gitBuilder: GitBuilder!
    var mockedNetwork: MockNetwork!
    var interactor: BotSyncingInteractor!
    var botDataStore: PlistBotDataStore!

    override func setUp() {
        setUpMockedNetwork()
        FileBotTemplateDataStore(file: testTemplateFile).save(testBotTemplate)
    }

    override func test() {
        setUpBotDataStore()
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            botDataStore: botDataStore
        )

        interactor.execute()
    }

    private func setUpBotDataStore() {
        botDataStore = PlistBotDataStore(file: testDataStoreFile)
        botDataStore.save(Bot(branchName: branch, id: botID))
    }

    func setUpMockedNetwork() {
        mockedNetwork = MockNetwork()
    }
}
