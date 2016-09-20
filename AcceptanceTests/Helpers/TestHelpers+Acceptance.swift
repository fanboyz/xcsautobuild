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
let testBotSynchroniser: BotSynchroniser = {
    return XCSBotSynchroniser(
        getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: Constants.network)),
        duplicateBotRequest: AnyXCSRequest(XCSDuplicateBotRequest(network: Constants.network)),
        deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: Constants.network)),
        botTemplateLoader: FileBotTemplatePersister(file: testTemplateFile)
    )
}()
class TestClass {}
let testBundleClass = TestClass.self
let testHost = "seans-macbook-pro-2.local"
let testBundle = NSBundle(forClass: testBundleClass)
let testPath = NSTemporaryDirectory() + "fitnesse_tests/"
let testDataStoreFile = testPath + "data_store"
let testTemplateFile = testPath + "templates"
let testGitPath = testPath + "git/"
let testLocalGitURL = NSURL(fileURLWithPath: testGitPath + "local")
let testRemoteGitURL = NSURL(fileURLWithPath: testGitPath + "origin")
let testXCSGitURL = NSURL(fileURLWithPath: testGitPath + "xcs")
let testGitBranchFetcher = GitBranchFetcher(directory: testLocalGitURL.path!)

func waitUntil(@autoclosure condition: () -> Bool, limit: Int = 20) {
    var count = 0
    while !condition() {
        wait(for: 0.05)
        count += 1
        if (count == limit) {
            break
        }
    }
}

func wait(for seconds: NSTimeInterval) {
    NSThread.sleepForTimeInterval(seconds)
}

func load(fileName: String, _ ext: String) -> NSData! {
    return NSData(contentsOfFile: testBundle.pathForResource(fileName, ofType: ext)!)
}

func fitnesseString(from bool: Bool) -> String {
    return bool ? yes : no
}
