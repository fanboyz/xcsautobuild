//
//  TestsHelpers.swift
//
//
//

import Foundation

func commaSeparatedList(from string: String) -> [String] {
    return string.componentsSeparatedByString(",").filter { $0 != "" }
}
