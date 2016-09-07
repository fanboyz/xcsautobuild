//
// Created by Sean Henry on 07/09/2016.
//

import Foundation

protocol PatternDataStoreProvider {
    var patternDataStore: PatternDataStore! { get set }
}

class GlobalBranchFilter: NSObject {

    static var branchFilter: BranchFilter {
        return wildcardBranchFilter
    }
    private static let wildcardBranchFilter = WildcardBranchFilter()

    @IBOutlet var patternDataStoreProvider: AnyObject? {
        didSet {
            var provider = patternDataStoreProvider as! PatternDataStoreProvider
            provider.patternDataStore = GlobalBranchFilter.wildcardBranchFilter
        }
    }
}
