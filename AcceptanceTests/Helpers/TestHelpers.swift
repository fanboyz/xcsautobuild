//
//  TestHelpers.swift
//
//
//

import Foundation

func commaSeparatedList(from string: String) -> [String] {
    return string.componentsSeparatedByString(",").filter { $0 != "" }
}

let yes = "yes"
let no = "no"
