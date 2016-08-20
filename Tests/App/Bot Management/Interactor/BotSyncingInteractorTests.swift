//
//  BotSyncingInteractorTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class BotSyncingInteractorTests: XCTestCase {
    
    var interactor: BotSyncingInteractor!
    var mockedDataStore: MockBranchesDataStore!
    var mockedBotCreator: MockBotCreator!
    var mockedBotDeleter: MockBotDeleter!

    override func setUp() {
        super.setUp()
        mockedDataStore = MockBranchesDataStore()
        mockedBotCreator = MockBotCreator()
        mockedBotDeleter = MockBotDeleter()
        interactor = BotSyncingInteractor(branchesDataStore: mockedDataStore, botCreator: mockedBotCreator, botDeleter: mockedBotDeleter)
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
        let result = mockedBotCreator.invokedBranches.map { $0.name }
        XCTAssertEqual(result, newBranches)
    }

    func test_execute_shouldGetDeletedBranches() {
        interactor.execute()
        XCTAssert(mockedDataStore.didGetDeletedBranches)
    }

    func test_execute_shouldDeleteBotForEachBranch() {
        let deletedBranches = ["develop", "feature/123"]
        stubDeletedBranchNames(deletedBranches)
        interactor.execute()
        let result = mockedBotDeleter.invokedBranches.map { $0.name }
        XCTAssertEqual(result, deletedBranches)
    }

    // MARK: - Helpers

    func stubNewBranchNames(names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedDataStore.stubbedNewBranches = branches
    }

    func stubDeletedBranchNames(names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedDataStore.stubbedDeletedBranches = branches
    }
}
