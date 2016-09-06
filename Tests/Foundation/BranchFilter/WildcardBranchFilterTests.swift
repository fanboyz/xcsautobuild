//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

import XCTest
@testable import xcsautobuild

class WildcardBranchFilterTests: XCTestCase {

    var filter: WildcardBranchFilter!
    let branches = [Branch(name: "feature/1"), Branch(name: "feature/2"), Branch(name: "hotfix/1"), Branch(name: "develop")]
    var featureBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "feature/2")] }
    var oneBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "hotfix/1")] }
    var eBranches: [Branch] { return [Branch(name: "feature/1"), Branch(name: "feature/2"), Branch(name: "develop")] }
    var developBranches: [Branch] { return [Branch(name: "develop")] }

    override func setUp() {
        super.setUp()
        filter = WildcardBranchFilter()
    }

    // MARK: - filterBranches

    func test_filterBranches_shouldHandleEmptyString() {
        XCTAssert(filterBranches().isEmpty)
    }

    func test_filterBranches_shouldReturnAllBranches_whenOnlyWildcard() {
        filter.filterString = "*"
        XCTAssertEqual(filterBranches(), branches)
    }

    func test_filterBranches_shouldReturnExactMatch() {
        filter.filterString = "feature/2"
        XCTAssertEqual(filterBranches(), [Branch(name: "feature/2")])
    }

    func test_filterBranches_shouldReturnPartialMatches_whenSuffixedWithWildcard() {
        filter.filterString = "feature/*"
        XCTAssertEqual(filterBranches(), featureBranches)
    }

    func test_filterBranches_shouldReturnPartialMatches_whenPrefixedWithWildcard() {
        filter.filterString = "*/1"
        XCTAssertEqual(filterBranches(), oneBranches)
    }
    
    func test_filterBranches_shouldReturnPartialMatches_whenPrefixedAndSuffixedWithWildcard() {
        filter.filterString = "*e*"
        XCTAssertEqual(filterBranches(), eBranches)
    }

    func test_filterBranches_shouldReturnPartialMatches_whenMultipleWildcards() {
        filter.filterString = "*dev*p*"
        XCTAssertEqual(filterBranches(), developBranches)
    }

    func test_filterBranches_shouldMatchRegexSpecialCharacters() {
        let specialCharacters = "[]()+?{}^$.|/\\"
        filter.filterString = specialCharacters
        let branches = [Branch(name: specialCharacters)]
        XCTAssertEqual(filter.filterBranches(branches), branches)
    }

    func test_filterBranches_shouldIgnoreInvalidRegex() {
        filter.filterString = "[(])"
        filterBranches() // should not crash
    }

    // MARK: - Helpers

    func filterBranches() -> [Branch] {
        return filter.filterBranches(branches)
    }
}
