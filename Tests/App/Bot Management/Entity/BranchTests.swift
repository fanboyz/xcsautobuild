//
//  BranchTests.swift
//
//
//

import XCTest
@testable import xcsautobuild

class BranchTests: XCTestCase {
    
    // MARK: - ==

    func test_equals_shouldBeTrue_whenNamesAreEqual() {
        XCTAssertEqual(Branch(name: "hi"), Branch(name: "hi"))
    }

    func test_equals_shouldBeFalse_whenNamesAreNotEqual() {
        XCTAssertNotEqual(Branch(name: "hi"), Branch(name: "hello"))
    }
}
