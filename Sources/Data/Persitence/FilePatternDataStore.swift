
import Foundation

class FilePatternDataStore: DataStore {

    private let file: String
    private let encoding = String.Encoding.utf8.rawValue

    init(file: String) {
        self.file = file
    }

    func save(_ data: String) {
        try? (data as NSString).write(toFile: file, atomically: true, encoding: encoding)
    }

    func load() -> String? {
        let string = try? NSString(contentsOfFile: file, encoding: encoding)
        return string as String?
    }
}
