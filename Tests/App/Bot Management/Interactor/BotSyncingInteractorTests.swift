//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class BotSyncingInteractorTests: XCTestCase {
    
    var interactor: BotSyncingInteractor!
    var mockedDataStore: MockBranchesDataStore!
    var mockedBotCreator: MockBotCreator!
    var mockedBotDeleter: MockBotDeleter!
    var mockedBranchFilter: MockBranchFilter!

    override func setUp() {
        super.setUp()
        mockedDataStore = MockBranchesDataStore()
        mockedBotCreator = MockBotCreator()
        mockedBotDeleter = MockBotDeleter()
        mockedBranchFilter = MockBranchFilter()
        interactor = BotSyncingInteractor(
                branchesDataStore: mockedDataStore,
                botCreator: mockedBotCreator,
                botDeleter: mockedBotDeleter,
                branchFilter: mockedBranchFilter
            )
    }
    
    // MARK: - execute

    func test_execute_shouldLoad() {
        interactor.execute()
        XCTAssert(mockedDataStore.didLoad)
    }

    func test_execute_shouldGetNewBranches() {
        interactor.execute()
        XCTAssert(mockedDataStore.didGetNewBranches)
    }

    func test_execute_shouldCommit() {
        interactor.execute()
        XCTAssert(mockedDataStore.didCommit)
    }

    func test_execute_shouldCreateNewBotForEachBranch() {
        let newBranches = ["develop", "master"]
        stubNewBranchNames(newBranches)
        interactor.execute()
        XCTAssertEqual(createdBotNames(), newBranches)
    }

    func test_execute_shouldGetDeletedBranches() {
        interactor.execute()
        XCTAssert(mockedDataStore.didGetDeletedBranches)
    }

    func test_execute_shouldDeleteBotForEachBranch() {
        let deletedBranches = ["develop", "feature/123"]
        stubDeletedBranchNames(deletedBranches)
        interactor.execute()
        XCTAssertEqual(deletedBotNames(), deletedBranches)
    }

    func test_execute_shouldFilterBranches() {
        let createdBranches = ["1", "2"]
        stubNewBranchNames(createdBranches)
        mockedBranchFilter.stubbedFilteredBranches = [Branch(name: "filtered")]
        interactor.execute()
        XCTAssertEqual(filteredBranchNames(), createdBranches)
        XCTAssertEqual(createdBotNames(), ["filtered"])
    }

    // MARK: - Helpers

    func stubNewBranchNames(names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedBranchFilter.stubbedFilteredBranches = branches
        mockedDataStore.stubbedNewBranches = branches
    }

    func stubDeletedBranchNames(names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedDataStore.stubbedDeletedBranches = branches
    }

    func createdBotNames() -> [String] {
        return mockedBotCreator.invokedBranches.map { $0.name }
    }

    func deletedBotNames() -> [String] {
        return mockedBotDeleter.invokedBranches.map { $0.name }
    }

    func filteredBranchNames() -> [String] {
        return mockedBranchFilter.invokedBranches!.map { $0.name }
    }
}
