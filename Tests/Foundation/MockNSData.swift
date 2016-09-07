//
//  MockNSData.swift
//
//
//

import XCTest
import Foundation

class MockNSData: NSData {

    var didWriteToFile = false
    var invokedPath: String?
    var invokedAtomically: Bool?
    override func writeToFile(path: String, atomically useAuxiliaryFile: Bool) -> Bool {
        didWriteToFile = true
        invokedPath = path
        invokedAtomically = useAuxiliaryFile
        return false
    }
}
