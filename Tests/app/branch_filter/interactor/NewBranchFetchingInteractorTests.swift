//
//  NewBranchFetchingInteractorTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class NewBranchFetchingInteractorTests: XCTestCase {
    
    var interactor: NewBranchFetchingInteractor!
    var mockedNewBranchesFetcher: MockNewBranchesFetcher!
    var mockedBotCreator: MockBotCreator!

    override func setUp() {
        super.setUp()
        mockedNewBranchesFetcher = MockNewBranchesFetcher()
        mockedBotCreator = MockBotCreator()
        interactor = NewBranchFetchingInteractor(newBranchesFetcher: mockedNewBranchesFetcher, botCreator: mockedBotCreator)
    }
    
    // MARK: - execute
    
    func test_execute_shouldFetchNewBranches() {
        interactor.execute()
        XCTAssert(mockedNewBranchesFetcher.didFetchNewBranches)
    }

    func test_execute_shouldCreateNewBotForEachBranch() {
        let branches = [Branch(name: "master"), Branch(name: "develop")]
        mockedNewBranchesFetcher.stubbedBranches = branches
        interactor.execute()
        XCTAssertEqual(mockedBotCreator.invokedBranches, branches.map({ $0.name }))
    }
}
