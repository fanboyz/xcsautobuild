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
    var eBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "feature/2"), Branch(name: "develop")] }
    var developBranches: [Branch] { return [Branch(name: "develop")] }

    override func setUp() {
        super.setUp()
        mockedStore = MockPatternDataStore()
        filter = WildcardBranchFilter(patternDataStore: mockedStore)
    }

    // MARK: - pattern

    func test_pattern_shouldLoadFromDataStore() {
        setPattern("branch/*")
        XCTAssertEqual(filter.pattern, mockedStore.stubbedPattern)
    }

    func test_pattern_shouldReturnWildcard_whenNoSavedPattern() {
        setPattern(nil)
        XCTAssertEqual(filter.pattern, "*")
    }

    // MARK: - filterBranches

    func test_filterBranches_shouldHandleEmptyString() {
        setPattern("")
        XCTAssert(filterBranches().isEmpty)
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
        XCTAssertEqual(filterBranches(), eBranches)
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

    // MARK: - Helpers

    func filterBranches() -> [Branch] {
        return filter.filter(branches)
    }

    func setPattern(_ pattern: String?) {
        mockedStore.stubbedPattern = pattern
    }
}
