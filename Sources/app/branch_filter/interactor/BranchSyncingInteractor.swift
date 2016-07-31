//
//  BranchSyncingInteractor.swift
//
//
//

import Foundation

class BranchSyncingInteractor: Command {

    private let branchesDataStore: BranchesDataStore
    private let botCreator: BotCreator
    private let botDeleter: BotDeleter

    init(branchesDataStore: BranchesDataStore, botCreator: BotCreator, botDeleter: BotDeleter) {
        self.branchesDataStore = branchesDataStore
        self.botCreator = botCreator
        self.botDeleter = botDeleter
    }

    func execute() {
        branchesDataStore.load()
        let newBranches = branchesDataStore.getNewBranches()
        let deletedBranches = branchesDataStore.getDeletedBranches()
        branchesDataStore.commit()
        newBranches.forEach { botCreator.createBot(forBranch: $0) }
        deletedBranches.forEach { botDeleter.deleteBot(forBranch: $0) }
    }
}
