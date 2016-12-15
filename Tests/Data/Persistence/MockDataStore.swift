@testable import xcsautobuild

class MockDataStore<DataType>: DataStore {

    var didSave = false
    var invokedData: DataType?

    func save(_ data: DataType) {
        didSave = true
        invokedData = data
    }

    var didLoad = false
    var stubbedData: DataType?

    func load() -> DataType? {
        didLoad = true
        return stubbedData
    }
}
