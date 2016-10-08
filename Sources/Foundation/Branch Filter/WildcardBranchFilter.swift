//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

class WildcardBranchFilter: BranchFilter, PatternDataStore {

    var pattern = ""
    private let wildcard = "*"

    func filterBranches(_ branches: [Branch]) -> [Branch] {
        if pattern == "" { return [] }
        let escaped = escapeSpecialCharacters(in: pattern)
        let regexPattern = replaceWildcardWithRegexWildcard(escaped)
        let strictPattern = matchFromBeginningAndToEnd(regexPattern)
        return filterBranches(branches, withPattern: strictPattern)
    }

    private func escapeSpecialCharacters(in string: String) -> String {
        let matching = try! NSRegularExpression(pattern: specialCharacterPattern(), options: [])
        return matching.stringByReplacingMatches(in: pattern, options: [], range: NSRange(0..<pattern.utf16.count), withTemplate: "\\\\$1")
    }

    private func filterBranches(_ branches: [Branch], withPattern pattern: String) -> [Branch] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
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
