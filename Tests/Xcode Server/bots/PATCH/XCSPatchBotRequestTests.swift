import XCTest
@testable import xcsautobuild

class XCSPatchBotRequestTests: XCTestCase {

    var request: XCSPatchBotRequest!
    var mockedNetwork: MockHTTPRequestSender!

    override func setUp() {
        super.setUp()
        mockedNetwork = MockHTTPRequestSender()
        request = XCSPatchBotRequest(requestSender: mockedNetwork)
    }

    // MARK: - createRequest

    func test_createRequest() {
        let data = PatchBotRequestData(id: "bot_id", dictionary: ["name": "bot_name"])
        let result = request.createRequest(data)
        XCTAssertEqual(result.path, "/bots/\(data.id)?overwriteBlueprint=true")
        XCTAssertEqual(result.method, .patch)
        XCTAssertEqual(result.jsonBody as NSDictionary?, data.dictionary as NSDictionary)
    }

    // MARK: - parse

    func test_parse() {
        XCTAssertNotNil(request.parse(response: Data()))
    }
}
