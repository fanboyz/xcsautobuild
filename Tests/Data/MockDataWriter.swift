
import XCTest
import Foundation
@testable import xcsautobuild

class MockDataWriter: DataWriter {

    var didWriteToFile = false
    var invokedPath: String?
    func write(data: Data, toFile path: String) {
        didWriteToFile = true
        invokedPath = path
    }
}
