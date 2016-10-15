//
// Created by Sean Henry on 07/09/2016.
//

import Foundation

protocol PatternDataStore {
    func save(pattern: String)
    func load() -> String?
}
