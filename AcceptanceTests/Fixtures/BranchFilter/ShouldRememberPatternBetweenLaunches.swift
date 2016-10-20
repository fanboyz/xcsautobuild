
@objc(ShouldRememberPatternBetweenLaunches)
class ShouldRememberPatternBetweenLaunches: DecisionTable {
    
    // MARK: - input
    var savedPattern: String!
    
    // MARK: - output
    var restoredPattern: String!
    
    // MARK: - test
    let dataStore = FilePatternDataStore(file: testFilterPatternFile)
    
    override func setUp() {
        dataStore.save(pattern: savedPattern)
    }
    
    override func test() {
        restoredPattern = WildcardBranchFilter(patternDataStore: dataStore).patterns.joined()
    }
}
