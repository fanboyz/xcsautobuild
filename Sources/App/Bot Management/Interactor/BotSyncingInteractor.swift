//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class BotSyncingInteractor: Command {

    private let branchFetcher: BranchFetcher
    private let botSynchroniser: BotSynchroniser
    private let branchFilter: BranchFilter
    private let botDataStore: BotDataStore

    init(branchFetcher: BranchFetcher, botSynchroniser: BotSynchroniser, branchFilter: BranchFilter, botDataStore: BotDataStore) {
        self.branchFetcher = branchFetcher
        self.botSynchroniser = botSynchroniser
        self.branchFilter = branchFilter
        self.botDataStore = botDataStore
    }

    func execute() {
        let filteredBranches = fetchFilteredBranches()
        let storedBots = botDataStore.load()
        let newBranches = findNewBranches(in: filteredBranches, byExcludingMatchingBotsIn: storedBots)
        let existingBots = findExistingBots(in: storedBots, byMatchingBranchesIn: filteredBranches)
        let botsToDelete = findExpiredBots(in: storedBots, byMatchingBranchesIn: filteredBranches)
        createBots(from: newBranches)
        synchronise(existingBots)
        delete(botsToDelete)
    }

    private func fetchFilteredBranches() -> [Branch] {
        let allBranches = branchFetcher.fetchBranches()
        return branchFilter.filter(allBranches)
    }

    private func findNewBranches(in branches: [Branch], byExcludingMatchingBotsIn bots: [Bot]) -> [Branch] {
        return branches.filter { branch in
            return !bots.contains(where: sameNames(branch))
        }
    }

    private func sameNames(_ branch: Branch) -> (Bot) -> Bool {
        return { bot in branch.name == bot.branchName }
    }

    private func findExistingBots(in bots: [Bot], byMatchingBranchesIn branches: [Branch]) -> [Bot] {
        return bots.filter { bot in
            branches.contains(where: sameNames(bot))
        }
    }

    private func findExpiredBots(in bots: [Bot], byMatchingBranchesIn branches: [Branch]) -> [Bot] {
        return bots.filter { bot in
            !branches.contains(where: sameNames(bot))
        }
    }

    private func sameNames(_ bot: Bot) -> (Branch) -> Bool {
        return { branch in bot.branchName == branch.name }
    }

    private func createBots(from branches: [Branch]) {
        branches.map(toBot).forEach(synchronise)
    }

    private func toBot(_ branch: Branch) -> Bot {
        return Bot(branchName: branch.name, id: nil)
    }

    private func synchronise(_ bots: [Bot]) {
        bots.forEach(synchronise)
    }

    private func synchronise(_ bot: Bot) {
        botSynchroniser.synchronise(bot) { [weak self] resultBot in
            self?.botDataStore.save(resultBot)
        }
    }

    private func delete(_ bots: [Bot]) {
        bots.forEach(delete)
    }

    private func delete(_ bot: Bot) {
        botSynchroniser.delete(bot) { [weak self] isSuccess in
            guard isSuccess else { return }
            self?.botDataStore.delete(bot)
        }
    }
}
