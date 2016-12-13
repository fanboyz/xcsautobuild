
class AnyDataStore<DataType>: DataStore {

    private let _save: (DataType) -> ()
    private let _load: () -> (DataType?)

    init<T: DataStore>(_ dataStore: T) where T.DataType == DataType {
        _save = dataStore.save
        _load = dataStore.load
    }

    func save(_ data: DataType) {
        _save(data)
    }

    func load() -> DataType? {
        return _load()
    }
}
