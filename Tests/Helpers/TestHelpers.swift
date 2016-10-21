
import Foundation
import FlexiJSON
@testable import xcsautobuild

let testRepoFingerprint = "93138D460F513226B44C11D1DC747F2BE36A21CE"
let testRepoID = "C214B4F4246A49E51CAE71AA5C1349A716302EB4"
let testRequest = HTTPRequest(path: "/test/request/path?key=value", method: .get, jsonBody: [:])
let testBranch = Branch(name: "test")
let testTemplateBotID = "template_bot_id"
let testTemplateBotJSON = ["name": "template bot", "_id": testTemplateBotID]
let testTemplateBotData = FlexiJSON(dictionary: testTemplateBotJSON).data!
let testBotTemplate = BotTemplate(name: testTemplateBotJSON["name"]!, data: testTemplateBotData)
let testBotName = "xcsautobuild [master]"
let testBotID = "6139a72b95fdeec94b49ec0a1f00191a"
let testBotJSON = ["name": testBotName, "_id": testBotID]
let testBotData = FlexiJSON(dictionary: testBotJSON).data!
let testPrimaryRepoKey = "C214B4F4246A49E51CAE71AA5C1349A716302EB4"
let testData = "data".data(using: String.Encoding.utf8)!
let testURL = URL(string: "https://test.com")!
let testBundle = Bundle(for: TestClass.self)

private class TestClass {}

func load(_ fileName: String, _ ext: String) -> Data! {
    return (try? Data(contentsOf: URL(fileURLWithPath: testBundle.path(forResource: fileName, ofType: ext)!)))
}

extension String {

    var utf8Data: Data {
        return data(using: String.Encoding.utf8)!
    }
}
