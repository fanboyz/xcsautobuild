//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class XCSBotSynchroniserTests: XCTestCase {

    var syncer: XCSBotSynchroniser!
    var mockedGetBotRequest: MockXCSRequest<String, NSData>!
    var mockedCreateBotRequest: MockXCSRequest<[String: AnyObject], Void>!
    var mockedTemplateLoader: MockBotTemplateLoader!
    let master = XCSBranch(name: "master", botID: "bot_id")

    override func setUp() {
        super.setUp()
        mockedGetBotRequest = MockXCSRequest()
        mockedCreateBotRequest = MockXCSRequest()
        mockedTemplateLoader = MockBotTemplateLoader()
        syncer = XCSBotSynchroniser(
                getBotRequest: AnyXCSRequest(mockedGetBotRequest),
                createBotRequest: AnyXCSRequest(mockedCreateBotRequest),
                botTemplateLoader: mockedTemplateLoader
        )
        stubValidTemplate()
    }

    // MARK: - synchroniseBot

    func test_synchroniseBot_shouldSendRequest_whenNoTemplate() {
        stubNoTemplate()
        synchroniseBot(from: master)
        XCTAssertFalse(mockedGetBotRequest.didSend)
        XCTAssertFalse(mockedCreateBotRequest.didSend)
    }

    func test_synchroniseBot_shouldCreateBot_whenNoBotID() {
        let newBranch = XCSBranch(name: "new", botID: nil)
        synchroniseBot(from: newBranch)
        XCTAssertEqual(mockedCreateBotRequest.invokedData as NSDictionary?, modifiedTemplateJSON(withName: "new"))
    }

    func test_synchroniseBot_shouldSendGetBotRequest() {
        synchroniseBot(from: master)
        XCTAssert(mockedGetBotRequest.didSend)
    }

    func test_synchroniseBot_shouldCreateBot_whenBotIsNotFound() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: NSData(), statusCode: 404)
        synchroniseBot(from: master)
        XCTAssertEqual(mockedCreateBotRequest.invokedData as NSDictionary?, modifiedTemplateJSON(withName: "master"))
    }

    func test_synchroniseBot_shouldNotCreateBot_whenBotIsFound() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: NSData(), statusCode: 200)
        synchroniseBot(from: master)
        XCTAssertFalse(mockedCreateBotRequest.didSend)
    }

    func test_synchroniseBot_shouldNotCreateBot_whenNoResponse() {
        mockedGetBotRequest.stubbedResponse = nil
        synchroniseBot(from: master)
        XCTAssertFalse(mockedCreateBotRequest.didSend)
    }

    // MARK: - Helpers

    func synchroniseBot(from branch: XCSBranch) {
        syncer.synchroniseBot(fromBranch: branch)
    }

    func modifiedTemplateJSON(withName name: String) -> [String: AnyObject] {
        var json = testTemplateJSON
        json["name"] = "xcsautobuild [\(name)]"
        return json
    }

    func stubValidTemplate() {
        mockedTemplateLoader.stubbedTemplate = testBotTemplate
    }

    func stubNoTemplate() {
        mockedTemplateLoader.stubbedTemplate = nil
    }
}
