//
//  MockDataLoader.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockDataLoader: DataLoader {

    var stubbedData: NSData?
    func loadData(from file: String) -> NSData? {
        return stubbedData
    }
}
