import XCTest
@testable import xcsautobuild

class XCSPatchBotRequestTests: XCTestCase {

    var request: XCSPatchBotRequest!
    var mockedNetwork: MockNetwork!

    override func setUp() {
        super.setUp()
        mockedNetwork = MockNetwork()
        request = XCSPatchBotRequest(network: mockedNetwork)
    }

    // MARK: - createRequest

    func test_createRequest() {
        let data = PatchBotRequestData(id: "bot_id", dictionary: ["name": "bot_name"])
        let result = request.createRequest(data)
        XCTAssertEqual(result.url, request.endpoint + "/bots/\(data.id)")
        XCTAssertEqual(result.method, .patch)
        XCTAssertEqual(result.jsonBody as NSDictionary?, data.dictionary as NSDictionary)
    }

    // MARK: - parse

    func test_parse() {
        XCTAssertNil(request.parse(response: Data()))
    }
}
