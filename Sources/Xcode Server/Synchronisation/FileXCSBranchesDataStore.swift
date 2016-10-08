//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

class FileXCSBranchesDataStore: XCSBranchesDataStore {

    private let file: String

    init(file: String) {
        self.file = file
    }

    func load() -> [XCSBranch] {
        return loadBranches().flatMap { XCSBranch(dictionary: $0.1) }
    }

    func load(fromBranchName name: String) -> XCSBranch? {
        let branches = loadBranches()
        return XCSBranch(dictionary: branches[name])
    }

    func save(branch: XCSBranch) {
        var branches = loadBranches()
        branches[branch.name] = branch.dictionary
        save(branches: branches)
    }

    func delete(branch: XCSBranch) {
        var branches = loadBranches()
        branches.removeValue(forKey: branch.name)
        save(branches: branches)
    }

    private func loadBranches() -> [String: [String: Any]] {
        return NSDictionary(contentsOfFile: file) as? [String: [String: Any]] ?? [:]
    }

    private func save(branches: [String: [String: Any]]) {
        let dictionary = branches as NSDictionary
        dictionary.write(toFile: file, atomically: true)
    }
}

extension XCSBranch {

    fileprivate var dictionary: [String: Any] {
        var result = ["name": name]
        if let botID = botID {
            result["botID"] = botID
        }
        return result
    }

    fileprivate init?(dictionary: [String: Any]?) {
        guard let name = dictionary?["name"] as? String else { return nil }
        self.init(name: name, botID: dictionary?["botID"] as? String)
    }
}
