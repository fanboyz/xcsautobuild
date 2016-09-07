//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockDataLoader: DataLoader {

    var stubbedData: NSData?
    func loadData(from file: String) -> NSData? {
        return stubbedData
    }
}
