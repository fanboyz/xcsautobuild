//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

protocol BotDataStore {
    func load() -> [Bot]
    func load(fromBranchName name: String) -> Bot?
    func save(_ branch: Bot)
    func delete(_ branch: Bot)
}
