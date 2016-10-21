
import XCTest
@testable import xcsautobuild

class MockDataLoader: DataLoader {

    var stubbedData: Data?
    func loadData(from file: String) -> Data? {
        return stubbedData
    }
}
