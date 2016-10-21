
import Foundation

protocol DataLoader {
    func loadData(from file: String) -> Data?
}

class DefaultDataLoader: DataLoader {

    func loadData(from file: String) -> Data? {
        return try? Data(contentsOf: URL(fileURLWithPath: file))
    }
}
