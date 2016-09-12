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
        synchroniseBots(from: newBranches)
        synchroniseBots(from: existingBranches)
    }

    private func fetchFilteredBranches() -> [Branch] {
        let allBranches = branchFetcher.fetchBranches()
        return branchFilter.filterBranches(allBranches)
    }

    private func findNewBranches(in branches: [Branch], byExcludingMatchingBranchesIn excluding: [XCSBranch]) -> [Branch] {
        return branches.filter { branch in
            return !excluding.contains(sameNames(branch))
        }
    }

    private func sameNames(branch: Branch) -> (XCSBranch) -> Bool {
        return { other in branch.name == other.name }
    }

    private func findExistingBranches(in branches: [XCSBranch], byMatchingBranchesIn matching: [Branch]) -> [XCSBranch] {
        return branches.filter { branch in
            matching.contains(sameNames(branch))
        }
    }

    private func sameNames(branch: XCSBranch) -> (Branch) -> Bool {
        return { other in branch.name == other.name }
    }

    private func synchroniseBots(from branches: [Branch]) {
        branches.forEach { botSynchroniser.synchroniseBot(fromBranch: newBranch(fromName: $0.name)) }
    }

    private func synchroniseBots(from branches: [XCSBranch]) {
        branches.forEach { botSynchroniser.synchroniseBot(fromBranch: $0) }
    }

    private func newBranch(fromName name: String) -> XCSBranch {
        return XCSBranch(name: name, botID: nil)
    }
}
