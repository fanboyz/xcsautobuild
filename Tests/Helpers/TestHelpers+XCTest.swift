//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import XCTest

func Assert(_ expression: @autoclosure () throws -> Bool?, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssert(try expression() ?? false, message, file: file, line: line)
}
