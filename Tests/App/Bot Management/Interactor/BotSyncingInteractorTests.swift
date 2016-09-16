//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class BotSyncingInteractorTests: XCTestCase {
    
    var interactor: BotSyncingInteractor!
    var mockedBranchFetcher: MockBranchFetcher!
    var mockedBotSynchroniser: MockBotSynchroniser!
    var mockedBranchFilter: MockBranchFilter!
    var mockedBranchesDataStore: MockXCSBranchesDataStore!
    let master = XCSBranch(name: "master", botID: "bot_id")
    let develop = XCSBranch(name: "develop", botID: "bot_id_2")

    override func setUp() {
        super.setUp()
        mockedBranchFetcher = MockBranchFetcher()
        mockedBotSynchroniser = MockBotSynchroniser()
        mockedBranchFilter = MockBranchFilter()
        mockedBranchesDataStore = MockXCSBranchesDataStore()
        interactor = BotSyncingInteractor(
                branchFetcher: mockedBranchFetcher,
                botSynchroniser: mockedBotSynchroniser,
                branchFilter: mockedBranchFilter,
                branchesDataStore: mockedBranchesDataStore
            )
    }
    
    // MARK: - execute

    func test_execute_shouldFetchBranches() {
        execute()
        XCTAssert(mockedBranchFetcher.didFetchBranches)
    }

    func test_execute_shouldSyncBranch_whenExistsInStoredBranches() {
        stubFetchedBranchNames([master.name])
        stubStoredBranch(master)
        execute()
        XCTAssertEqual(synchronisedBranches(), [master])
    }

    func test_execute_shouldSyncBranches_whenTheyExistInStoredBranches() {
        stubFetchedBranchNames([develop.name, master.name])
        stubStoredBranches([master, develop])
        execute()
        XCTAssertEqual(synchronisedBranches(), [master, develop])
    }

    func test_execute_shouldSyncBranches_whenTheyDoNotExistInStoredBranches() {
        stubFetchedBranchNames(["new"])
        execute()
        XCTAssertEqual(synchronisedBranches(), [XCSBranch(name: "new", botID: nil)])
    }

    func test_execute_shouldFilterBranches() {
        let expected = [XCSBranch(name: "3", botID: nil)]
        let fetchedBranches = ["1", "2", "3"]
        stubFetchedBranchNames(fetchedBranches)
        stubStoredBranches(expected)
        mockedBranchFilter.stubbedFilteredBranches = [Branch(name: "3")]
        execute()
        XCTAssertEqual(filteredBranchNames(), fetchedBranches)
        XCTAssertEqual(synchronisedBranches(), expected)
    }

    func test_execute_shouldSaveSynchronisationResults_whenNewBranch() {
        let newBranch = XCSBranch(name: master.name, botID: nil)
        stubFetchedBranchNames([master.name])
        mockedBotSynchroniser.stubbedSynchronisedBranch = newBranch
        execute()
        XCTAssertEqual(mockedBranchesDataStore.invokedSavedBranch, newBranch)
    }

    func test_execute_shouldSaveSynchronisationResults_whenExistingBranchOutOfSync() {
        let invalidBranch = XCSBranch(name: master.name, botID: "invalid_bot_id")
        let validBranch = XCSBranch(name: master.name, botID: "valid_bot_id")
        stubFetchedBranchNames([master.name])
        stubStoredBranch(invalidBranch)
        mockedBotSynchroniser.stubbedSynchronisedBranch = validBranch
        execute()
        XCTAssertEqual(mockedBranchesDataStore.invokedSavedBranch, validBranch)
    }

    func test_execute_shouldDeleteBots_whenStoredBranchIsNotContainedInFilteredBranches() {
        stubFetchedBranchNames([develop.name])
        stubStoredBranches([develop, master])
        execute()
        XCTAssertEqual(mockedBotSynchroniser.invokedDeletedBranch, master)
    }

    func test_execute_shouldDeleteBots_whenStoredBranchesAreNotContainedInFilteredBranches() {
        stubFetchedBranchNames([])
        stubStoredBranches([develop, master])
        execute()
        XCTAssertEqual(mockedBotSynchroniser.invokedDeletedBranches, [develop, master])
    }

    func test_execute_shouldNotDeleteBot_whenStoredBranchIsNotContainedInFilteredBranches() {
        stubFetchedBranchNames([develop.name])
        stubStoredBranch(develop)
        execute()
        XCTAssertFalse(mockedBotSynchroniser.didDeleteBot)
    }

    func test_execute_shouldDeleteBranchFromDataStore_whenBotIsDeleted() {
        stubFetchedBranchNames([])
        stubStoredBranch(develop)
        stubSuccessfulBotDeletion()
        execute()
        XCTAssertEqual(mockedBranchesDataStore.invokedDeletedBranch, develop)
    }

    func test_execute_shouldNotDeleteBranchFromDataStore_whenDeletingTheBotFails() {
        stubFetchedBranchNames([])
        stubStoredBranch(develop)
        stubUnsuccessfulBotDeletion()
        execute()
        XCTAssertFalse(mockedBranchesDataStore.didDelete)
    }

    // MARK: - Helpers

    func execute() {
        interactor.execute()
    }

    func stubFetchedBranchNames(names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedBranchFilter.stubbedFilteredBranches = branches
        mockedBranchFetcher.stubbedBranches = branches
    }

    func stubStoredBranch(branch: XCSBranch) {
        stubStoredBranches([branch])
    }

    func stubStoredBranches(branches: [XCSBranch]) {
        mockedBranchesDataStore.stubbedLoadedBranches = branches
    }

    func synchronisedBranches() -> [XCSBranch] {
        return mockedBotSynchroniser.invokedSynchronisedBranches
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
