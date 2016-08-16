//
//  TestHelpers+XCTest.swift
//
//
//

import Foundation
import XCTest

func Assert(@autoclosure expression: () throws -> BooleanType?, @autoclosure _ message: () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssert(try expression() ?? false, message, file: file, line: line)
}