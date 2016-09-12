//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

class FileXCSBranchesDataStore: XCSBranchesDataStore {

    private let file: String

    init(file: String) {
        self.file = file
    }

    func load(fromBranchName name: String) -> XCSBranch? {
        let branches = loadBranches()
        return XCSBranch(dictionary: branches[name])
    }

    func save(branch branch: XCSBranch) {
        var branches = loadBranches()
        branches[branch.name] = branch.dictionary
        save(branches: branches)
    }

    private func loadBranches() -> [String: [String: AnyObject]] {
        return NSDictionary(contentsOfFile: file) as? [String: [String: AnyObject]] ?? [:]
    }

    private func save(branches branches: [String: [String: AnyObject]]) {
        let dictionary = branches as NSDictionary
        dictionary.writeToFile(file, atomically: true)
    }
}

extension XCSBranch {

    private var dictionary: [String: AnyObject] {
        var result = ["name": name]
        if let botID = botID {
            result["botID"] = botID
        }
        return result
    }

    private init?(dictionary: [String: AnyObject]?) {
        guard let name = dictionary?["name"] as? String else { return nil }
        self.init(name: name, botID: dictionary?["botID"] as? String)
    }
}
