//
// Created by Sean Henry on 15/10/2016.
//

import Foundation
@testable import xcsautobuild

class MockPatternDataStore: PatternDataStore {

    var stubbedPattern: String?
    func load() -> String? {
        return stubbedPattern
    }

    var didSave = false
    func save(pattern: String) {
        didSave = true
    }
}

