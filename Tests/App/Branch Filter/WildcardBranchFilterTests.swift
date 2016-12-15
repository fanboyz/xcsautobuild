
import Foundation

import XCTest
@testable import xcsautobuild

class WildcardBranchFilterTests: XCTestCase {

    var filter: WildcardBranchFilter!
    var mockedStore: MockDataStore<String>!

    override func setUp() {
        super.setUp()
        mockedStore = MockDataStore()
        filter = WildcardBranchFilter(patternDataStore: AnyDataStore(mockedStore))
    }

    // MARK: - patterns

    func test_patterns_shouldLoadFromDataStore() {
        setPatterns("branch/*")
        XCTAssertEqual(filter.patterns, ["branch/*"])
    }

    func test_patterns_shouldLoadMultilinePatternFromDataStore() {
        setPatterns("branch/*", "feature/*")
        XCTAssertEqual(filter.patterns, ["branch/*", "feature/*"])
    }

    func test_patterns_shouldReturnWildcard_whenNoSavedPattern() {
        setPattern(nil)
        XCTAssertEqual(filter.patterns, ["*"])
    }

    func test_patterns_shouldReturnWildcard_whenSingleEmptyStringArray() {
        setPattern("")
        XCTAssertEqual(filter.patterns, ["*"])
    }

    func test_patterns_shouldIgnoreEmptyLines() {
        setPatterns("", "feature/*", "")
        XCTAssertEqual(filter.patterns, ["feature/*"])
    }

    func test_patterns_shouldIgnoreWhitespaceOnlyLines() {
        setPatterns("      ", "feature/*", " ")
        XCTAssertEqual(filter.patterns, ["feature/*"])
    }

    // MARK: - filterBranches

    func test_filterBranches_shouldReturnAllBranches_whenOnlyEmptyString() {
        setPattern("")
        assert(branches: ["feature/1", "develop", "feature/2"], match: ["feature/1", "develop", "feature/2"])
    }

    func test_filterBranches_shouldReturnAllBranches_whenOnlyWildcard() {
        setPattern("*")
        assert(branches: ["feature/1", "develop", "feature/2"], match: ["feature/1", "develop", "feature/2"])
    }

    func test_filterBranches_shouldReturnExactMatch() {
        setPattern("feature/2")
        assert(branches: ["feature/1", "feature/2"], match: ["feature/2"])
    }

    func test_filterBranches_shouldReturnPartialMatches_whenSuffixedWithWildcard() {
        setPattern("feature/*")
        assert(branches: ["feature/1", "develop", "feature/2"], match: ["feature/1", "feature/2"])
    }

    func test_filterBranches_shouldReturnPartialMatches_whenPrefixedWithWildcard() {
        setPattern("*/1")
        assert(branches: ["feature/1", "develop", "release/1", "hotfix/1"], match: ["feature/1", "release/1", "hotfix/1"])
    }
    
    func test_filterBranches_shouldReturnPartialMatches_whenPrefixedAndSuffixedWithWildcard() {
        setPattern("*e*")
        assert(branches: ["feature/1", "develop", "release/1", "hotfix/1"], match: ["feature/1", "develop", "release/1"])
    }

    func test_filterBranches_shouldReturnPartialMatches_whenMultipleWildcards() {
        setPattern("*dev*p*")
        assert(branches: ["feature/1", "develop", "release/1"], match: ["develop"])
    }

    func test_filterBranches_shouldMatchRegexSpecialCharacters() {
        let specialCharacters = "[]()+?{}^$.|/\\"
        setPattern(specialCharacters)
        assert(branches: [specialCharacters], match: [specialCharacters])
    }

    func test_filterBranches_shouldIgnoreInvalidRegex() {
        setPattern("[(])")
        _ = filter.filter([Branch(name: "develop")]) // should not crash
    }

    func test_filterBranches_shouldStartMatchingFromBeginningOfTheString() {
        setPattern("evelop")
        assert(branches: ["develop"], match: [])
    }

    func test_filterBranches_shouldStopMatchingAtEndOfTheString() {
        setPattern("develo")
        assert(branches: ["develop"], match: [])
    }

    func test_filterBranches_shouldMatchFromAnyOfTheMultiplePatterns() {
        setPatterns("feature/*", "hotfix/*")
        assert(branches: ["feature/1", "hotfix/1", "develop"], match: ["feature/1", "hotfix/1"])
    }

    func test_filterBranches_shouldBeCaseInsensitive() {
        setPattern("feature/*")
        assert(branches: ["Feature/1", "FEATURE/2", "FeATurE/3"], match: ["Feature/1", "FEATURE/2", "FeATurE/3"])
    }

    // MARK: - Helpers
    
    func assert(branches: [String], match expected: [String], file: StaticString = #file, line: UInt = #line) {
        let filtered = filter.filter(branches.map(toBranch))
        XCTAssertEqual(filtered, expected.map(toBranch), file: file, line: line)
    }
    
    func toBranch(_ name: String) -> Branch {
        return Branch(name: name)
    }

    func setPatterns(_ patterns: String...) {
        mockedStore.stubbedData = patterns.joined(separator: "\n")
    }

    func setPattern(_ pattern: String?) {
        mockedStore.stubbedData = pattern
    }
}
