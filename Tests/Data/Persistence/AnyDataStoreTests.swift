import XCTest
@testable import xcsautobuild

class AnyDataStoreTests: XCTestCase {

    var store: AnyDataStore<String>!
    var mockedStore: MockDataStore<String>!
    let data = "data"

    override func setUp() {
        super.setUp()
        mockedStore = MockDataStore()
        store = AnyDataStore(mockedStore)
    }

    // MARK: - save

    func test_save() {
        store.save(data)
        XCTAssertEqual(mockedStore.invokedData, data)
    }

    // MARK: - load

    func test_load() {
        mockedStore.stubbedData = data
        XCTAssertEqual(store.load(), data)
    }
}
