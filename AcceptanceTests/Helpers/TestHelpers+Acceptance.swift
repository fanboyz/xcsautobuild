//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

func commaSeparatedList(from string: String) -> [String] {
    return string.componentsSeparatedByString(",").filter { $0 != "" }
}

func commaSeparatedString(from array: [String]) -> String {
    if let first = array.first {
        return array[array.startIndex.advancedBy(1)..<array.endIndex].reduce(first) { $0 + "," + $1 }
    }
    return "nil"
}

let yes = "yes"
let no = "no"
let api = Constants.api
let botSynchroniser = Constants.botSynchroniser
class TestClass {}
let testBundleClass = TestClass.self
let testHost = "seans-macbook-pro-2.local"
let testBundle = NSBundle(forClass: testBundleClass)
let testBotID = "6139a72b95fdeec94b49ec0a1f00191a"
let testDataStoreFile = NSTemporaryDirectory() + "data_store"
let testTemplateFile = NSTemporaryDirectory() + "templates"

func waitUntil(@autoclosure condition: () -> Bool) {
    while !condition() {
        wait()
    }
}

func wait(for seconds: NSTimeInterval = 0.05) {
    NSThread.sleepForTimeInterval(0.05)
}

func load(fileName: String, _ ext: String) -> NSData! {
    return NSData(contentsOfFile: testBundle.pathForResource(fileName, ofType: ext)!)
}

func fitnesseString(from bool: Bool) -> String {
    return bool ? yes : no
}
