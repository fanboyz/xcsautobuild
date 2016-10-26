
import XCTest
@testable import xcsautobuild

class XCSGetBotRequestTests: XCTestCase {
    
    var request: XCSGetBotRequest!
    let id = "id123"
    
    override func setUp() {
        super.setUp()
        request = XCSGetBotRequest(requestSender: MockHTTPRequestSender())
    }
    
    // MARK: - createRequest
    
    func test_createRequest_shouldBuildPathWithBotID() {
        let expectedPath = "/bots/\(id)"
        let request = createRequest()
        XCTAssertEqual(request.path, expectedPath)
        XCTAssertEqual(request.method, HTTPMethod.get)
        XCTAssertNil(request.jsonBody)
    }

    // MARK: - parse

    func test_parse_shouldPassBackRawData() {
        XCTAssertEqual(request.parse(response: testData), testData)
    }

    // MARK: - Helpers

    func createRequest() -> HTTPRequest {
        return request.createRequest(id)
    }
}
