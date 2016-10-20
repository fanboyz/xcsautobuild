//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

import XCTest
@testable import xcsautobuild

class WildcardBranchFilterTests: XCTestCase {

    var filter: WildcardBranchFilter!
    var mockedStore: MockPatternDataStore!
    let branches = [Branch(name: "feature/1"), Branch(name: "feature/2"), Branch(name: "hotfix/1"), Branch(name: "develop")]
    var featureBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "feature/2")] }
    var oneBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "hotfix/1")] }
    var oneAndDevelopBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "hotfix/1"), Branch(name: "develop")] }
    var featureAndDevelopBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "feature/2"), Branch(name: "develop")] }
    var featureAndHotfixBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "feature/2"), Branch(name: "hotfix/1")] }
    var developBranches: [Branch] { return [Branch(name: "develop")] }

    override func setUp() {
        super.setUp()
        mockedStore = MockPatternDataStore()
        filter = WildcardBranchFilter(patternDataStore: mockedStore)
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
        XCTAssertEqual(filterBranches(), branches)
    }

    func test_filterBranches_shouldReturnAllBranches_whenOnlyWildcard() {
        setPattern("*")
        XCTAssertEqual(filterBranches(), branches)
    }

    func test_filterBranches_shouldReturnExactMatch() {
        setPattern("feature/2")
        XCTAssertEqual(filterBranches(), [Branch(name: "feature/2")])
    }

    func test_filterBranches_shouldReturnPartialMatches_whenSuffixedWithWildcard() {
        setPattern("feature/*")
        XCTAssertEqual(filterBranches(), featureBranches)
    }

    func test_filterBranches_shouldReturnPartialMatches_whenPrefixedWithWildcard() {
        setPattern("*/1")
        XCTAssertEqual(filterBranches(), oneBranches)
    }
    
    func test_filterBranches_shouldReturnPartialMatches_whenPrefixedAndSuffixedWithWildcard() {
        setPattern("*e*")
        XCTAssertEqual(filterBranches(), featureAndDevelopBranches)
    }

    func test_filterBranches_shouldReturnPartialMatches_whenMultipleWildcards() {
        setPattern("*dev*p*")
        XCTAssertEqual(filterBranches(), developBranches)
    }

    func test_filterBranches_shouldMatchRegexSpecialCharacters() {
        let specialCharacters = "[]()+?{}^$.|/\\"
        setPattern(specialCharacters)
        let branches = [Branch(name: specialCharacters)]
        XCTAssertEqual(filter.filter(branches), branches)
    }

    func test_filterBranches_shouldIgnoreInvalidRegex() {
        setPattern("[(])")
        _ = filterBranches() // should not crash
    }

    func test_filterBranches_shouldStartMatchingFromBeginningOfTheString() {
        setPattern("evelop")
        XCTAssert(filterBranches().isEmpty)
    }

    func test_filterBranches_shouldStopMatchingAtEndOfTheString() {
        setPattern("develo")
        XCTAssert(filterBranches().isEmpty)
    }

    func test_filterBranches_shouldMatchFromAnyOfTheMultiplePatterns() {
        setPatterns("feature/*", "hotfix/*")
        XCTAssertEqual(filterBranches(), featureAndHotfixBranches)
        setPatterns("f*", "*p")
        XCTAssertEqual(filterBranches(), featureAndDevelopBranches)
        setPatterns("*1", "*p")
        XCTAssertEqual(filterBranches(), oneAndDevelopBranches)
    }

    // MARK: - Helpers

    func filterBranches() -> [Branch] {
        return filter.filter(branches)
    }

    func setPatterns(_ patterns: String...) {
        mockedStore.stubbedPattern = patterns.joined(separator: "\n")
    }

    func setPattern(_ pattern: String?) {
        mockedStore.stubbedPattern = pattern
    }
}
