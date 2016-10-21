//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

class WildcardBranchFilter: BranchFilter {

    var patterns: [String] {
        let result = patternDataStore.load()?
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { $0 != "" } ?? ["*"]
        return result.count > 0 ? result : ["*"]
    }
    
    private let wildcard = "*"
    private let patternDataStore: PatternDataStore

    init(patternDataStore: PatternDataStore) {
        self.patternDataStore = patternDataStore
    }

    func filter(_ branches: [Branch]) -> [Branch] {
        let escaped = escapeSpecialCharacters(in: patterns)
        let regexPattern = replaceWildcardWithRegexWildcard(escaped)
        let strictPattern = matchFromBeginningAndToEnd(regexPattern)
        return filter(branches, withPattern: strictPattern)
    }

    private func escapeSpecialCharacters(in patterns: [String]) -> String {
        let matching = try! NSRegularExpression(pattern: specialCharacterPattern(), options: [])
        return patterns.map { pattern in
            matching.stringByReplacingMatches(in: pattern, options: [], range: NSRange(0..<pattern.utf16.count), withTemplate: "\\\\$1")
        }.joined(separator: "|")
    }

    private func filter(_ branches: [Branch], withPattern pattern: String) -> [Branch] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        return branches.filter { regex.numberOfMatches(in: $0.name, options: [], range: NSMakeRange(0, $0.name.characters.count)) > 0 }
    }

    private func replaceWildcardWithRegexWildcard(_ filterString: String) -> String {
        return filterString.replacingOccurrences(of: "*", with: ".*")
    }

    private func specialCharacterPattern() -> String {
        // matches []()+?{}^$.|/\
        return "([\\[\\]\\(\\)\\+\\?\\{\\}\\^\\$\\.\\|\\/\\\\])"
    }

    private func matchFromBeginningAndToEnd(_ pattern: String) -> String {
        return "^" + pattern + "$"
    }
}
