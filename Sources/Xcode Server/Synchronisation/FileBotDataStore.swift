
import Foundation

class FileBotDataStore: BotDataStore {

    private let file: String

    init(file: String) {
        self.file = file
    }

    func load() -> [Bot] {
        return loadBots().flatMap { Bot(dictionary: $0.1) }
    }

    func load(fromBranchName name: String) -> Bot? {
        let bots = loadBots()
        return Bot(dictionary: bots[name])
    }

    func save(_ bot: Bot) {
        var bots = loadBots()
        bots[bot.branchName] = bot.dictionary
        save(dictionary: bots)
    }

    func delete(_ bot: Bot) {
        var bots = loadBots()
        bots.removeValue(forKey: bot.branchName)
        save(dictionary: bots)
    }

    private func loadBots() -> [String: [String: Any]] {
        return NSDictionary(contentsOfFile: file) as? [String: [String: Any]] ?? [:]
    }

    private func save(dictionary: [String: [String: Any]]) {
        let dictionary = dictionary as NSDictionary
        dictionary.write(toFile: file, atomically: true)
    }
}

extension Bot {

    fileprivate var dictionary: [String: Any] {
        var result = ["branchName": branchName]
        if let id = id {
            result["id"] = id
        }
        return result
    }

    fileprivate init?(dictionary: [String: Any]?) {
        guard let name = dictionary?["branchName"] as? String else { return nil }
        self.init(branchName: name, id: dictionary?["id"] as? String)
    }
}
