//
//  FlexiJSON+DictionaryLiteralConvertibleTests.swift
//
//  Copyright © 2016 Sean Henry. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
@testable import xcsautobuild

class FlexiJSON_DictionaryLiteralConvertibleTests: XCTestCase {

    func test_dictionaryLiteralConvertible() {
        var json = FlexiJSON(dictionary: ["1": 123])
        json["1"] = ["3": 456, "4": "string", "5": ["string"], "6": NSNull(), "7": true]

        let expected = FlexiJSON(dictionary: ["3": 456, "4": "string", "5": ["string"], "6": NSNull(), "7": true])
        let result = json["1"]
        XCTAssertEqual(result, expected)
    }
}