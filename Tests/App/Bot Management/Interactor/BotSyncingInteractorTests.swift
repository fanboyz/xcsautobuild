//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class BotSyncingInteractorTests: XCTestCase {
    
    var interactor: BotSyncingInteractor!
    var mockedBranchFetcher: MockBranchFetcher!
    var mockedBotCreator: MockBotCreator!
    var mockedBranchFilter: MockBranchFilter!

    override func setUp() {
        super.setUp()
        mockedBranchFetcher = MockBranchFetcher()
        mockedBotCreator = MockBotCreator()
        mockedBranchFilter = MockBranchFilter()
        interactor = BotSyncingInteractor(
                branchFetcher: mockedBranchFetcher,
                botCreator: mockedBotCreator,
                branchFilter: mockedBranchFilter
            )
    }
    
    // MARK: - execute

    func test_execute_shouldFetchBranches() {
        interactor.execute()
        XCTAssert(mockedBranchFetcher.didFetchBranches)
    }

    func test_execute_shouldCreateNewBotForEachBranch() {
        let newBranches = ["develop", "master"]
        stubNewBranchNames(newBranches)
        interactor.execute()
        XCTAssertEqual(createdBotNames(), newBranches)
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
        mockedBranchFetcher.stubbedBranches = branches
    }

    func createdBotNames() -> [String] {
        return mockedBotCreator.invokedBranches.map { $0.name }
    }

    func filteredBranchNames() -> [String] {
        return mockedBranchFilter.invokedBranches!.map { $0.name }
    }
}
