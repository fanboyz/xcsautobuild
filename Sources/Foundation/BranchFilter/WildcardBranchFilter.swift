//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

class WildcardBranchFilter: BranchFilter {

    var filterString = ""
    private let wildcard = "*"

    func filterBranches(branches: [Branch]) -> [Branch] {
        if filterString == "" { return [] }
        let escaped = escapeSpecialCharacters(in: filterString)
        let pattern = replaceWildcardWithRegexWildcard(escaped)
        return filterBranches(branches, withPattern: pattern)
    }

    private func escapeSpecialCharacters(in string: String) -> String {
        let matching = try! NSRegularExpression(pattern: specialCharacterPattern(), options: [])
        return matching.stringByReplacingMatchesInString(filterString, options: [], range: NSRange(0..<filterString.utf16.count), withTemplate: "\\\\$1")
    }

    private func filterBranches(branches: [Branch], withPattern pattern: String) -> [Branch] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return branches.filter { regex.numberOfMatchesInString($0.name, options: [], range: NSMakeRange(0, $0.name.characters.count)) > 0 }
    }

    private func replaceWildcardWithRegexWildcard(filterString: String) -> String {
        return filterString.stringByReplacingOccurrencesOfString("*", withString: ".*")
    }

    private func specialCharacterPattern() -> String {
        // matches []()+?{}^$.|/\
        return "([\\[\\]\\(\\)\\+\\?\\{\\}\\^\\$\\.\\|\\/\\\\])"
    }
}
