
import Foundation
import ObjectiveGit

func commaSeparatedList(from string: String) -> [String] {
    return string.components(separatedBy: ",").filter { $0 != "" }
}

func commaSeparatedString(from array: [String]) -> String {
    if let first = array.first {
        return array[array.indices.suffix(from: array.startIndex.advanced(by: 1))].reduce(first) { $0 + "," + $1 }
    }
    return "nil"
}

let yes = "yes"
let no = "no"
let xcsConfiguration = XCSConfiguration(host: "test-host", userName: "xcs_username", password: "xcs_password")
let requestSender = Dependencies.createRequestSender(xcsConfiguration: xcsConfiguration)
let api = Dependencies.createAPI(requestSender: requestSender)
let testBotSynchroniser: BotSynchroniser = {
    return XCSBotSynchroniser(
        getBotRequest:  AnyXCSRequest(XCSGetBotRequest(requestSender: requestSender)),
        duplicateBotRequest: AnyXCSRequest(XCSDuplicateBotRequest(requestSender: requestSender)),
        deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(requestSender: requestSender)),
        patchBotRequest: AnyXCSRequest(XCSPatchBotRequest(requestSender: requestSender)),
        botTemplateDataStore: botTemplateDataStore
    )
}()

let testHost = xcsConfiguration.host
let testPath = NSTemporaryDirectory() + "fitnesse_tests/"
let testDataStoreFile = testPath + "data_store"
let testTemplateFile = testPath + "templates"
let testFilterPatternFile = testPath + "templates"
let testGitPath = testPath + "git/"
let testLocalGitURL = URL(fileURLWithPath: testGitPath + "local")
let testRemoteGitURL = URL(fileURLWithPath: testGitPath + "origin")
let testGitBranchFetcher = GitBranchFetcher(directory: URL(fileURLWithPath: testLocalGitURL.path), remoteName: "origin", credentialProvider: credentialProvider)
private let credential = try! GTCredential(userName: "", password: "")
private let credentialProvider = GTCredentialProvider { _ in credential }

let botTemplateDataStore = AnyDataStore(FileBotTemplateDataStore(file: testTemplateFile))
let patternDataStore = AnyDataStore(FilePatternDataStore(file: testFilterPatternFile))

func waitUntil(_ condition: @autoclosure () -> Bool, limit: Int = 20) {
    var count = 0
    while !condition() {
        wait(for: 0.05)
        count += 1
        if (count == limit) {
            break
        }
    }
}

func wait(for seconds: TimeInterval) {
    Thread.sleep(forTimeInterval: seconds)
}

func fitnesseString(from bool: Bool) -> String {
    return bool ? yes : no
}
