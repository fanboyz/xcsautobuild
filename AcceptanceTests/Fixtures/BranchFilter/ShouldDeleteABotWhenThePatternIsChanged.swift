
@objc(ShouldDeleteABotWhenThePatternIsChanged)
class ShouldDeleteABotWhenThePatternIsChanged: DecisionTable, GitFixture {
    
    // MARK: - input
    var existingBotID: String!
    
    // MARK: - output
    var botDeleted: String!
    
    // MARK: - test
    let branch = "develop"
    var botDataStore: FileBotDataStore!
    var gitBuilder: GitBuilder!
    var network: MockNetwork!
    var interactor: BotSyncingInteractor!
    
    override func setUp() {
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
        setUpGit(branches: "develop")
        expectToDeleteBot()
        saveExistingBranch()
        
        let patternDataStore = FilePatternDataStore(file: testFilterPatternFile)
        patternDataStore.save(pattern: "non_matching")
        let filter = WildcardBranchFilter(patternDataStore: patternDataStore)
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: filter,
            botDataStore: botDataStore
        )
    }
    
    override func test() {
        interactor.execute()
        waitUntil(network.deleteBotCount > 0)
        botDeleted = fitnesseString(from: (network.deletedBotIDs[0] == existingBotID))
    }
    
    private func expectToDeleteBot() {
        network = MockNetwork()
        network.expectDeleteBot(id: existingBotID)
    }
    
    private func saveExistingBranch() {
        botDataStore = FileBotDataStore(file: testDataStoreFile)
        botDataStore.save(Bot(branchName: branch, id: existingBotID))
    }
}
