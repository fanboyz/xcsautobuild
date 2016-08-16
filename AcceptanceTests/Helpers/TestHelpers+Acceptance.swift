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
let networkConfiguration = NSURLSessionNetwork.Configuration(username: "username", password: "password")
let network = NSURLSessionNetwork(configuration: networkConfiguration)
let api = XcodeServerBotAPI(
    createBotRequest: AnyXCSRequest(XCSPostBotsRequest(network: network)),
    getBotsRequest: AnyXCSRequest(XCSGetBotsRequest(network: network)),
    deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: network)),
    getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: network))
)
class TestClass {}
let testBundleClass = TestClass.self
let testHost = "seans-macbook-pro-2.local"
let testBundle = NSBundle(forClass: testBundleClass)
let testBotID = "6139a72b95fdeec94b49ec0a1f00191a"
let testDataStoreFile = NSTemporaryDirectory() + "data_store"

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
