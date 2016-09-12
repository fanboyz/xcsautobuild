//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class BotSyncingInteractor: Command {

    private let branchFetcher: BranchFetcher
    private let botCreator: BotCreator
    private let branchFilter: BranchFilter

    init(branchFetcher: BranchFetcher, botCreator: BotCreator, branchFilter: BranchFilter) {
        self.branchFetcher = branchFetcher
        self.botCreator = botCreator
        self.branchFilter = branchFilter
    }

    func execute() {
        let allBranches = branchFetcher.fetchBranches()
        let filteredBranches = branchFilter.filterBranches(allBranches)
        filteredBranches.forEach { botCreator.createBot(forBranch: $0) }
    }
}
