//
//  NewBranchFetchingInteractorTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class NewBranchFetchingInteractorTests: XCTestCase {
    
    var interactor: NewBranchFetchingInteractor!
    var mockedDataStore: MockBranchesDataStore!
    var mockedBotCreator: MockBotCreator!

    override func setUp() {
        super.setUp()
        mockedDataStore = MockBranchesDataStore()
        mockedBotCreator = MockBotCreator()
        interactor = NewBranchFetchingInteractor(branchesDataStore: mockedDataStore, botCreator: mockedBotCreator)
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
        XCTAssertEqual(mockedBotCreator.invokedBranches, newBranches)
    }

    // MARK: - Helpers

    func stubNewBranchNames(names: [String]) {
        let branches = names.map { Branch(name: $0) }
        mockedDataStore.stubbedNewBranches = branches
    }
}
