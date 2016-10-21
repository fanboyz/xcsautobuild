
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
let api = Dependencies.api
let testBotSynchroniser: BotSynchroniser = {
    return XCSBotSynchroniser(
        getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: Dependencies.network)),
        duplicateBotRequest: AnyXCSRequest(XCSDuplicateBotRequest(network: Dependencies.network)),
        deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: Dependencies.network)),
        patchBotRequest: AnyXCSRequest(XCSPatchBotRequest(network: Dependencies.network)),
        botTemplateLoader: FileBotTemplateDataStore(file: testTemplateFile)
    )
}()

let testHost = Configuration.xcsHostName
let testPath = NSTemporaryDirectory() + "fitnesse_tests/"
let testDataStoreFile = testPath + "data_store"
let testTemplateFile = testPath + "templates"
let testFilterPatternFile = testPath + "templates"
let testGitPath = testPath + "git/"
let testLocalGitURL = URL(fileURLWithPath: testGitPath + "local")
let testRemoteGitURL = URL(fileURLWithPath: testGitPath + "origin")
let testGitBranchFetcher = GitBranchFetcher(directory: testLocalGitURL.path, remoteName: "origin", credentialProvider: Configuration.gitCredentialProvider)
private let credential = try! GTCredential(userName: "", password: "")

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
