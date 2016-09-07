//
// Created by Sean Henry on 07/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class GlobalBranchFilterTests: XCTestCase {

    var globalBranchFilter: GlobalBranchFilter!

    override func setUp() {
        super.setUp()
        globalBranchFilter = GlobalBranchFilter()
    }

    // MARK: - branchFilter

    func test_branchFilter_shouldBeWildcardFilter() {
        XCTAssert(GlobalBranchFilter.branchFilter is WildcardBranchFilter)
    }

    // MARK: - patternDataStoreProvider

    func test_patternDataStoreProvider_shouldSetGlobalBranchFilterOnProvider() {
        let provider = MockPatternDataStoreProvider()
        globalBranchFilter.patternDataStoreProvider = provider
        XCTAssert(provider.patternDataStore is WildcardBranchFilter)
    }
}
