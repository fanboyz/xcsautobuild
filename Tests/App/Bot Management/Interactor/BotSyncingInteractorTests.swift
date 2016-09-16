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
    let masterBranch = XCSBranch(name: "master", botID: "bot_id")
    let developBranch = XCSBranch(name: "develop", botID: "bot_id_2")

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
        stubFetchedBranchNames(["master"])
        stubStoredBranch(masterBranch)
        execute()
        XCTAssertEqual(synchronisedBranches(), [masterBranch])
    }

    func test_execute_shouldSyncBranches_whenTheyExistInStoredBranches() {
        stubFetchedBranchNames(["develop", "master"])
        stubStoredBranches([masterBranch, developBranch])
        execute()
        XCTAssertEqual(synchronisedBranches(), [masterBranch, developBranch])
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
        let newBranch = XCSBranch(name: "master", botID: nil)
        stubFetchedBranchNames(["master"])
        mockedBotSynchroniser.stubbedBranch = newBranch
        execute()
        XCTAssertEqual(mockedBranchesDataStore.invokedBranch, newBranch)
    }

    func test_execute_shouldSaveSynchronisationResults_whenExistingBranchOutOfSync() {
        let invalidBranch = XCSBranch(name: "master", botID: "invalid_bot_id")
        let validBranch = XCSBranch(name: "master", botID: "valid_bot_id")
        stubFetchedBranchNames(["master"])
        stubStoredBranch(invalidBranch)
        mockedBotSynchroniser.stubbedBranch = validBranch
        execute()
        XCTAssertEqual(mockedBranchesDataStore.invokedBranch, validBranch)
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
        mockedBranchesDataStore.stubbedBranches = branches
    }

    func synchronisedBranches() -> [XCSBranch] {
        return mockedBotSynchroniser.invokedBranches
    }

    func filteredBranchNames() -> [String] {
        return mockedBranchFilter.invokedBranches!.map { $0.name }
    }
}
