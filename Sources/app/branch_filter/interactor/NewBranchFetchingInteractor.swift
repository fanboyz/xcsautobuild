//
//  NewBranchFetchingInteractor.swift
//
//
//

import Foundation

class NewBranchFetchingInteractor: Command {

    private let newBranchesFetcher: NewBranchesFetcher
    private let botCreator: BotCreator

    init(newBranchesFetcher: NewBranchesFetcher, botCreator: BotCreator) {
        self.newBranchesFetcher = newBranchesFetcher
        self.botCreator = botCreator
    }

    func execute() {
        newBranchesFetcher.fetchNewBranches { branches in
            branches.forEach { self.botCreator.createBot(forBranch: $0.name) }
        }
    }
}
