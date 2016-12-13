
protocol DataStore {
    associatedtype DataType
    func save(_ data: DataType)
    func load() -> DataType?
}
