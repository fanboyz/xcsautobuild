//
//  NewBranchFetchingInteractor.swift
//
//
//

import Foundation

class NewBranchFetchingInteractor: Command {

    private let branchesDataStore: BranchesDataStore
    private let botCreator: BotCreator

    init(branchesDataStore: BranchesDataStore, botCreator: BotCreator) {
        self.branchesDataStore = branchesDataStore
        self.botCreator = botCreator
    }

    func execute() {
        branchesDataStore.load()
        let newBranches = branchesDataStore.getNewBranches()
        branchesDataStore.commit()
        newBranches.forEach { botCreator.createBot(forBranch: $0.name) }
    }
}
