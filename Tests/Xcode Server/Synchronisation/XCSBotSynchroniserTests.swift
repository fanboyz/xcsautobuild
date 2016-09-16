//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class XCSBotSynchroniserTests: XCTestCase {

    var syncer: XCSBotSynchroniser!
    var mockedGetBotRequest: MockXCSRequest<String, NSData>!
    var mockedCreateBotRequest: MockXCSRequest<[String: AnyObject], String>!
    var mockedTemplateLoader: MockBotTemplateLoader!
    let master = XCSBranch(name: "master", botID: "master_bot_id")
    let newBranch = XCSBranch(name: "new", botID: nil)
    let newBotID = "new_bot_id"

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
        synchroniseBot(from: newBranch)
        XCTAssertEqual(mockedCreateBotRequest.invokedData as NSDictionary?, modifiedTemplateJSON(withName: "new"))
    }

    func test_synchroniseBot_shouldSendGetBotRequest() {
        synchroniseBot(from: master)
        XCTAssert(mockedGetBotRequest.didSend)
    }

    func test_synchroniseBot_shouldCreateBot_whenBotIsNotFound() {
        stubNotFoundGetBotResponse()
        synchroniseBot(from: master)
        XCTAssertEqual(mockedCreateBotRequest.invokedData as NSDictionary?, modifiedTemplateJSON(withName: "master"))
    }

    func test_synchroniseBot_shouldNotCreateBot_whenBotIsFound() {
        stubValidGetBotResponse()
        synchroniseBot(from: master)
        XCTAssertFalse(mockedCreateBotRequest.didSend)
    }

    func test_synchroniseBot_shouldNotCreateBot_whenNoResponse() {
        stubInvalidGetBotResponse()
        synchroniseBot(from: master)
        XCTAssertFalse(mockedCreateBotRequest.didSend)
    }

    func test_synchroniseBot_shouldCompleteWithSameBranch_whenNoTemplate() {
        stubNoTemplate()
        XCTAssertEqual(synchroniseBot(from: master), master)
    }

    func test_synchroniseBot_shouldCompleteWithNewBranch_whenBotIDDoesNotExist() {
        let fetchedBranch = XCSBranch(name: newBranch.name, botID: newBotID)
        stubValidCreateBotResponse(botID: fetchedBranch.botID!)
        XCTAssertEqual(synchroniseBot(from: newBranch), fetchedBranch)
    }

    func test_synchroniseBot_shouldCompleteWithSameBranch_whenBotIDDoesNotExist_andNetworkRequestFails() {
        let fetchedBranch = XCSBranch(name: newBranch.name, botID: newBotID)
        stubInvalidCreateBotResponse()
        XCTAssertEqual(synchroniseBot(from: newBranch), newBranch)
    }

    func test_synchroniseBot_shouldCompleteWithNewBranch_whenBotDoesNotExistOnServer() {
        stubNotFoundGetBotResponse()
        let fetchedBranch = XCSBranch(name: master.name, botID: newBotID)
        stubValidCreateBotResponse(botID: fetchedBranch.botID!)
        XCTAssertEqual(synchroniseBot(from: master), fetchedBranch)
    }

    func test_synchroniseBot_shouldCompleteWithSameBranch_whenBotAlreadyExistsOnServer() {
        stubValidGetBotResponse()
        XCTAssertEqual(synchroniseBot(from: master), master)
    }

    // MARK: - Helpers

    func synchroniseBot(from branch: XCSBranch) -> XCSBranch {
        var result: XCSBranch!
        syncer.synchroniseBot(fromBranch: branch) { b in
            result = b
        }
        return result
    }

    func modifiedTemplateJSON(withName name: String) -> [String: AnyObject] {
        var json = testTemplateBotJSON
        json["name"] = "xcsautobuild [\(name)]"
        return json
    }

    func stubValidTemplate() {
        mockedTemplateLoader.stubbedTemplate = testBotTemplate
    }

    func stubNoTemplate() {
        mockedTemplateLoader.stubbedTemplate = nil
    }

    func stubValidCreateBotResponse(botID botID: String) {
        mockedCreateBotRequest.stubbedResponse = XCSResponse(data: botID, statusCode: 200)
    }

    func stubInvalidCreateBotResponse() {
        mockedCreateBotRequest.stubbedResponse = nil
    }

    func stubInvalidGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = nil
    }

    func stubNotFoundGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: NSData(), statusCode: 404)
    }

    func stubValidGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: NSData(), statusCode: 200)
    }
}
