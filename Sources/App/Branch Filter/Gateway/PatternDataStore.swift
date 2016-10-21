
import Foundation

protocol PatternDataStore {
    func save(pattern: String)
    func load() -> String?
}
