
import XCTest
@testable import xcsautobuild

class BotSyncingInteractorTests: XCTestCase {
    
    var interactor: BotSyncingInteractor!
    var mockedBranchFetcher: MockBranchFetcher!
    var mockedBotSynchroniser: MockBotSynchroniser!
    var mockedBranchFilter: MockBranchFilter!
    var mockedBotDataStore: MockBotDataStore!
    let master = Bot(branchName: "master", id: "bot_id")
    let develop = Bot(branchName: "develop", id: "bot_id_2")

    override func setUp() {
        super.setUp()
        mockedBranchFetcher = MockBranchFetcher()
        mockedBotSynchroniser = MockBotSynchroniser()
        mockedBranchFilter = MockBranchFilter()
        mockedBotDataStore = MockBotDataStore()
        interactor = BotSyncingInteractor(
                branchFetcher: mockedBranchFetcher,
                botSynchroniser: mockedBotSynchroniser,
                branchFilter: mockedBranchFilter,
                botDataStore: mockedBotDataStore
            )
    }
    
    // MARK: - execute

    func test_execute_shouldFetchBranches() {
        execute()
        XCTAssert(mockedBranchFetcher.didFetchBranches)
    }

    func test_execute_shouldSyncBot_whenBotBranchNameExistsInBotDataStore() {
        stubFetchedBranchNames([master.branchName])
        stubStoredBot(master)
        execute()
        XCTAssertEqual(synchronisedBots(), [master])
    }

    func test_execute_shouldSyncBots_whenTheirBranchNamesExistInBotDataStore() {
        stubFetchedBranchNames([develop.branchName, master.branchName])
        stubStoredBots([master, develop])
        execute()
        XCTAssertEqual(synchronisedBots(), [master, develop])
    }

    func test_execute_shouldSyncBots_whenTheirBranchNamesDoNotExistInBotDataStore() {
        stubFetchedBranchNames(["new"])
        execute()
        XCTAssertEqual(synchronisedBots(), [Bot(branchName: "new", id: nil)])
    }

    func test_execute_shouldFilterBranches() {
        let expected = [Bot(branchName: "3", id: nil)]
        let fetchedBranches = ["1", "2", "3"]
        stubFetchedBranchNames(fetchedBranches)
        stubStoredBots(expected)
        mockedBranchFilter.stubbedFilteredBranches = [Branch(name: "3")]
        execute()
        XCTAssertEqual(filteredBranchNames(), fetchedBranches)
        XCTAssertEqual(synchronisedBots(), expected)
    }

    func test_execute_shouldSaveSynchronisationResults_whenNewBot() {
        let newBot = Bot(branchName: master.branchName, id: nil)
        stubFetchedBranchNames([master.branchName])
        mockedBotSynchroniser.stubbedSynchronisedBot = newBot
        execute()
        XCTAssertEqual(mockedBotDataStore.invokedSavedBot, newBot)
    }

    func test_execute_shouldSaveSynchronisationResults_whenExistingBotOutOfSync() {
        let invalidBot = Bot(branchName: master.branchName, id: "invalid_bot_id")
        let validBot = Bot(branchName: master.branchName, id: "valid_bot_id")
        stubFetchedBranchNames([master.branchName])
        stubStoredBot(invalidBot)
        mockedBotSynchroniser.stubbedSynchronisedBot = validBot
        execute()
        XCTAssertEqual(mockedBotDataStore.invokedSavedBot, validBot)
    }

    func test_execute_shouldDeleteBots_whenStoredBranchIsNotContainedInFilteredBranches() {
        stubFetchedBranchNames([develop.branchName])
        stubStoredBots([develop, master])
        execute()
        XCTAssertEqual(mockedBotSynchroniser.invokedDeletedBot, master)
    }

    func test_execute_shouldDeleteBots_whenStoredBotBranchNamesAreNotContainedInFilteredBranches() {
        stubFetchedBranchNames([])
        stubStoredBots([develop, master])
        execute()
        XCTAssertEqual(mockedBotSynchroniser.invokedDeletedBots, [develop, master])
    }

    func test_execute_shouldNotDeleteBot_whenStoredBotBranchNameIsNotContainedInFilteredBranches() {
        stubFetchedBranchNames([develop.branchName])
        stubStoredBot(develop)
        execute()
        XCTAssertFalse(mockedBotSynchroniser.didDelete)
    }

    func test_execute_shouldDeleteBotFromDataStore_whenBotIsDeleted() {
        stubFetchedBranchNames([])
        stubStoredBot(develop)
        stubSuccessfulBotDeletion()
        execute()
        XCTAssertEqual(mockedBotDataStore.invokedDeletedBot, develop)
    }

    func test_execute_shouldNotDeleteBotFromDataStore_whenDeletingTheBotFails() {
        stubFetchedBranchNames([])
        stubStoredBot(develop)
        stubUnsuccessfulBotDeletion()
        execute()
        XCTAssertFalse(mockedBotDataStore.didDelete)
    }

    // MARK: - Helpers

    func execute() {
        interactor.execute()
    }

    func stubFetchedBranchNames(_ names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedBranchFilter.stubbedFilteredBranches = branches
        mockedBranchFetcher.stubbedBranches = branches
    }

    func stubStoredBot(_ bot: Bot) {
        stubStoredBots([bot])
    }

    func stubStoredBots(_ bots: [Bot]) {
        mockedBotDataStore.stubbedLoadedBots = bots
    }

    func synchronisedBots() -> [Bot] {
        return mockedBotSynchroniser.invokedSynchronisedBots
    }

    func filteredBranchNames() -> [String] {
        return mockedBranchFilter.invokedBranches!.map { $0.name }
    }

    func stubSuccessfulBotDeletion() {
        mockedBotSynchroniser.stubbedDeletionResult = true
    }

    func stubUnsuccessfulBotDeletion() {
        mockedBotSynchroniser.stubbedDeletionResult = false
    }
}
