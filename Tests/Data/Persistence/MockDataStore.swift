@testable import xcsautobuild

class MockDataStore<DataType>: DataStore {

    var invokedData: DataType?

    func save(_ data: DataType) {
        invokedData = data
    }

    var didLoad = false
    var stubbedData: DataType?

    func load() -> DataType? {
        didLoad = true
        return stubbedData
    }
}
