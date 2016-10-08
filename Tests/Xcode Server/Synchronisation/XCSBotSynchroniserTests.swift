//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class XCSBotSynchroniserTests: XCTestCase {

    var syncer: XCSBotSynchroniser!
    var mockedGetBotRequest: MockXCSRequest<String, Data>!
    var mockedDuplicateBotRequest: MockXCSRequest<DuplicateBotRequestData, String>!
    var mockedDeleteBotRequest: MockXCSRequest<String, Void>!
    var mockedTemplateLoader: MockBotTemplateLoader!
    let master = XCSBranch(name: "master", botID: "master_bot_id")
    let newBranch = XCSBranch(name: "new", botID: nil)
    let newBotID = "new_bot_id"

    override func setUp() {
        super.setUp()
        mockedGetBotRequest = MockXCSRequest()
        mockedDuplicateBotRequest = MockXCSRequest()
        mockedDeleteBotRequest = MockXCSRequest()
        mockedTemplateLoader = MockBotTemplateLoader()
        syncer = XCSBotSynchroniser(
            getBotRequest: AnyXCSRequest(mockedGetBotRequest),
            duplicateBotRequest: AnyXCSRequest(mockedDuplicateBotRequest),
            deleteBotRequest: AnyXCSRequest(mockedDeleteBotRequest),
            botTemplateLoader: mockedTemplateLoader
        )
        stubValidTemplate()
    }

    // MARK: - synchroniseBot

    func test_synchroniseBot_shouldSendRequest_whenNoTemplate() {
        stubNoTemplate()
        synchroniseBot(from: master)
        XCTAssertFalse(mockedGetBotRequest.didSend)
        XCTAssertFalse(mockedDuplicateBotRequest.didSend)
    }

    func test_synchroniseBot_shouldCreateBot_whenNoBotID() {
        synchroniseBot(from: newBranch)
        XCTAssertEqual(mockedDuplicateBotRequest.invokedData?.id, testTemplateBotID)
        XCTAssertEqual(mockedDuplicateBotRequest.invokedData?.name, botName(for: newBranch))
    }

    func test_synchroniseBot_shouldSendGetBotRequest() {
        synchroniseBot(from: master)
        XCTAssert(mockedGetBotRequest.didSend)
    }

    func test_synchroniseBot_shouldCreateBot_whenBotIsNotFound() {
        stubNotFoundGetBotResponse()
        synchroniseBot(from: master)
        XCTAssertEqual(mockedDuplicateBotRequest.invokedData?.id, testTemplateBotID)
        XCTAssertEqual(mockedDuplicateBotRequest.invokedData?.name, botName(for: master))
    }

    func test_synchroniseBot_shouldNotCreateBot_whenBotIsFound() {
        stubValidGetBotResponse()
        synchroniseBot(from: master)
        XCTAssertFalse(mockedDuplicateBotRequest.didSend)
    }

    func test_synchroniseBot_shouldNotCreateBot_whenNoResponse() {
        stubInvalidGetBotResponse()
        synchroniseBot(from: master)
        XCTAssertFalse(mockedDuplicateBotRequest.didSend)
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

    // MARK: - deleteBot

    func test_deleteBot_shouldCompleteWithTrue_whenNoBotID() {
        XCTAssert(deleteBot(from: newBranch))
    }

    func test_deleteBot_shouldCompleteWithTrue_whenNetworkRespondsWith404NotFound() {
        stubDeleteBotResponse(statusCode: 404)
        XCTAssert(deleteBot(from: master))
    }

    func test_deleteBot_shouldCompleteWithTrue_whenNetworkRequestSucceeds() {
        stubDeleteBotResponse(statusCode: 204)
        XCTAssert(deleteBot(from: master))
    }

    func test_deleteBot_shouldCompleteWithFalse_whenNetworkRequestFails() {
        stubInvalidDeleteBotResponse()
        XCTAssertFalse(deleteBot(from: master))
    }

    func test_deleteBot_shouldCompleteWithFalse_whenNetworkRespondsWithBadStatusCode() {
        stubDeleteBotResponse(statusCode: 500)
        XCTAssertFalse(deleteBot(from: master))
    }

    // MARK: - Helpers

    func synchroniseBot(from branch: XCSBranch) -> XCSBranch {
        var result: XCSBranch!
        syncer.synchroniseBot(fromBranch: branch) { b in
            result = b
        }
        return result
    }

    func deleteBot(from branch: XCSBranch) -> Bool {
        var result: Bool!
        syncer.deleteBot(fromBranch: branch) { r in
            result = r
        }
        return result
    }

    func stubValidTemplate() {
        mockedTemplateLoader.stubbedTemplate = testBotTemplate
    }

    func stubNoTemplate() {
        mockedTemplateLoader.stubbedTemplate = nil
    }

    func stubValidCreateBotResponse(botID: String) {
        mockedDuplicateBotRequest.stubbedResponse = XCSResponse(data: botID, statusCode: 200)
    }

    func stubInvalidCreateBotResponse() {
        mockedDuplicateBotRequest.stubbedResponse = nil
    }

    func stubInvalidGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = nil
    }

    func stubNotFoundGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: Data(), statusCode: 404)
    }

    func stubValidGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = XCSResponse(data: Data(), statusCode: 200)
    }

    func stubDeleteBotResponse(statusCode: Int) {
        mockedDeleteBotRequest.stubbedResponse = XCSResponse(data: (), statusCode: statusCode)
    }

    func stubInvalidDeleteBotResponse() {
        mockedDeleteBotRequest.stubbedResponse = nil
    }

    func botName(for branch: XCSBranch) -> String {
        return "xcsautobuild [\(branch.name)]"
    }
}
