
import Foundation

class FilePatternDataStore: PatternDataStore {

    private let file: String

    init(file: String) {
        self.file = file
    }

    func save(pattern: String) {
        try? (pattern as NSString).write(toFile: file, atomically: true, encoding: String.Encoding.utf8.rawValue)
    }

    func load() -> String? {
        let string = try? NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue)
        return string as String?
    }
}
