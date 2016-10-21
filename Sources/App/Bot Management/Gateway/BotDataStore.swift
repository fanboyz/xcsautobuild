
import Foundation

protocol BotDataStore {
    func load() -> [Bot]
    func load(fromBranchName name: String) -> Bot?
    func save(_ branch: Bot)
    func delete(_ branch: Bot)
}
