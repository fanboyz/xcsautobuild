import Foundation

protocol DataWriter {
    func write(data: Data, toFile path: String)
}

class DefaultDataWriter: DataWriter {
    
    func write(data: Data, toFile path: String) {
        try? data.write(to: URL(fileURLWithPath: path))
    }
}
