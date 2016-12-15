
@objc(ShouldRememberPatternBetweenLaunches)
class ShouldRememberPatternBetweenLaunches: DecisionTable {
    
    // MARK: - input
    var savedPattern: String!
    
    // MARK: - output
    var restoredPattern: String!
    
    // MARK: - test
    override func setUp() {
        patternDataStore.save(savedPattern)
    }
    
    override func test() {
        restoredPattern = WildcardBranchFilter(patternDataStore: patternDataStore).patterns.joined()
    }
}
