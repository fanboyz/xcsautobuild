//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class BotSyncingInteractor: Command {

    private let branchesDataStore: BranchesDataStore
    private let botCreator: BotCreator
    private let botDeleter: BotDeleter
    private let branchFilter: BranchFilter

    init(branchesDataStore: BranchesDataStore, botCreator: BotCreator, botDeleter: BotDeleter, branchFilter: BranchFilter) {
        self.branchesDataStore = branchesDataStore
        self.botCreator = botCreator
        self.botDeleter = botDeleter
        self.branchFilter = branchFilter
    }

    func execute() {
        branchesDataStore.load()
        let allBranches = branchFilter.filterBranches(branchesDataStore.getAllBranches())
        let deletedBranches = branchesDataStore.getDeletedBranches()
        branchesDataStore.commit()
        allBranches.forEach { botCreator.createBot(forBranch: $0) }
        deletedBranches.forEach { botDeleter.deleteBot(forBranch: $0) }
    }
}
