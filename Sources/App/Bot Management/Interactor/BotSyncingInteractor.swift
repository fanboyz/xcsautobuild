//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class BotSyncingInteractor: Command {

    private let branchFetcher: BranchFetcher
    private let botSynchroniser: BotSynchroniser
    private let branchFilter: BranchFilter
    private let branchesDataStore: XCSBranchesDataStore

    init(branchFetcher: BranchFetcher, botSynchroniser: BotSynchroniser, branchFilter: BranchFilter, branchesDataStore: XCSBranchesDataStore) {
        self.branchFetcher = branchFetcher
        self.botSynchroniser = botSynchroniser
        self.branchFilter = branchFilter
        self.branchesDataStore = branchesDataStore
    }

    func execute() {
        let filteredBranches = fetchFilteredBranches()
        let storedBranches = branchesDataStore.load()
        let newBranches = findNewBranches(in: filteredBranches, byExcludingMatchingBranchesIn: storedBranches)
        let existingBranches = findExistingBranches(in: storedBranches, byMatchingBranchesIn: filteredBranches)
        let deletedBranches = findExpiredBranches(in : storedBranches, byMatchingBranchesIn: filteredBranches)
        synchroniseBots(from: newBranches)
        synchroniseBots(from: existingBranches)
        deleteBots(from: deletedBranches)
    }

    private func fetchFilteredBranches() -> [Branch] {
        let allBranches = branchFetcher.fetchBranches()
        return branchFilter.filterBranches(allBranches)
    }

    private func findNewBranches(in branches: [Branch], byExcludingMatchingBranchesIn excluding: [XCSBranch]) -> [Branch] {
        return branches.filter { branch in
            return !excluding.contains(where: sameNames(branch))
        }
    }

    private func sameNames(_ branch: Branch) -> (XCSBranch) -> Bool {
        return { other in branch.name == other.name }
    }

    private func findExistingBranches(in branches: [XCSBranch], byMatchingBranchesIn matching: [Branch]) -> [XCSBranch] {
        return branches.filter { branch in
            matching.contains(where: sameNames(branch))
        }
    }

    private func findExpiredBranches(in branches: [XCSBranch], byMatchingBranchesIn matching: [Branch]) -> [XCSBranch] {
        return branches.filter { branch in
            !matching.contains(where: sameNames(branch))
        }
    }

    private func sameNames(_ branch: XCSBranch) -> (Branch) -> Bool {
        return { other in branch.name == other.name }
    }

    private func synchroniseBots(from branches: [Branch]) {
        branches.map(toXCSBranch).forEach(synchroniseBot)
    }

    private func toXCSBranch(_ branch: Branch) -> XCSBranch {
        return newBranch(fromName: branch.name)
    }

    private func synchroniseBots(from branches: [XCSBranch]) {
        branches.forEach(synchroniseBot)
    }

    private func synchroniseBot(from branch: XCSBranch) {
        botSynchroniser.synchroniseBot(fromBranch: branch) { [weak self] resultBranch in
            self?.branchesDataStore.save(branch: resultBranch)
        }
    }

    private func newBranch(fromName name: String) -> XCSBranch {
        return XCSBranch(name: name, botID: nil)
    }

    private func deleteBots(from branches: [XCSBranch]) {
        branches.forEach(deleteBot)
    }

    private func deleteBot(from branch: XCSBranch) {
        botSynchroniser.deleteBot(fromBranch: branch) { [weak self] result in
            guard result else { return }
            self?.branchesDataStore.delete(branch: branch)
        }
    }
}
