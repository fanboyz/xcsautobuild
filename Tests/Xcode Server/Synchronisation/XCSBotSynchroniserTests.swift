
import Foundation
import XCTest
import FlexiJSON
@testable import xcsautobuild

class XCSBotSynchroniserTests: XCTestCase {

    var syncer: XCSBotSynchroniser!
    var mockedGetBotRequest: MockXCSRequest<String, Data>!
    var mockedDuplicateBotRequest: MockXCSRequest<DuplicateBotRequestData, String>!
    var mockedDeleteBotRequest: MockXCSRequest<String, Void>!
    var mockedPatchBotRequest: MockXCSRequest<PatchBotRequestData, Void>!
    var mockedTemplateLoader: MockBotTemplateLoader!
    let master = Bot(branchName: "master", id: "master_bot_id")
    let newBot = Bot(branchName: "new", id: nil)
    let newBotID = "new_bot_id"

    override func setUp() {
        super.setUp()
        mockedGetBotRequest = MockXCSRequest()
        mockedDuplicateBotRequest = MockXCSRequest()
        mockedDeleteBotRequest = MockXCSRequest()
        mockedPatchBotRequest = MockXCSRequest()
        mockedTemplateLoader = MockBotTemplateLoader()
        syncer = XCSBotSynchroniser(
            getBotRequest: AnyXCSRequest(mockedGetBotRequest),
            duplicateBotRequest: AnyXCSRequest(mockedDuplicateBotRequest),
            deleteBotRequest: AnyXCSRequest(mockedDeleteBotRequest),
            patchBotRequest: AnyXCSRequest(mockedPatchBotRequest),
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
        synchroniseBot(from: newBot)
        XCTAssertEqual(mockedDuplicateBotRequest.invokedData?.id, testTemplateBotID)
        XCTAssertEqual(mockedDuplicateBotRequest.invokedData?.name, botName(for: newBot))
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

    func test_synchroniseBot_shouldCompleteWithSameBot_whenNoTemplate() {
        stubNoTemplate()
        XCTAssertEqual(synchroniseBot(from: master), master)
    }

    func test_synchroniseBot_shouldCompleteWithNewBot_whenBotIDDoesNotExist() {
        let duplicatedBot = Bot(branchName: newBot.branchName, id: newBotID)
        stubValidDuplicateBotResponse(botID: duplicatedBot.id!)
        stubValidGetDuplicatedBotResponse()
        stubValidPatchBotResponse()
        XCTAssertEqual(synchroniseBot(from: newBot), duplicatedBot)
    }

    func test_synchroniseBot_shouldCompleteWithSameBot_whenBotIDDoesNotExist_andNetworkRequestFails() {
        stubInvalidDuplicateBotResponse()
        XCTAssertEqual(synchroniseBot(from: newBot), newBot)
    }

    func test_synchroniseBot_shouldCompleteWithNewBot_whenBotDoesNotExistOnServer() {
        let duplicatedBot = Bot(branchName: master.branchName, id: newBotID)
        stubNotFoundGetBotResponse()
        stubValidDuplicateBotResponse(botID: newBotID)
        stubValidGetDuplicatedBotResponse()
        stubValidPatchBotResponse()
        XCTAssertEqual(synchroniseBot(from: master), duplicatedBot)
    }

    func test_synchroniseBot_shouldCompleteWithSameBot_whenBotAlreadyExistsOnServer() {
        stubValidGetBotResponse()
        XCTAssertEqual(synchroniseBot(from: master), master)
    }

    func test_synchroniseBot_shouldPatchBotBranchName() {
        let duplicatedBot = Bot(branchName: newBot.branchName, id: newBotID)
        stubValidGetDuplicatedBotResponse()
        stubValidDuplicateBotResponse(botID: newBotID)
        stubValidPatchBotResponse()
        XCTAssertEqual(synchroniseBot(from: newBot), duplicatedBot)
        XCTAssertEqual(mockedPatchBotRequest.invokedData?.id, newBotID)
        XCTAssertEqual(branchName(fromBotDictionary: mockedPatchBotRequest.invokedData!.dictionary), newBot.branchName)
    }

    func test_synchroniseBot_shouldCompleteWithSameBot_whenFailingToPatch() {
        stubValidDuplicateBotResponse(botID: newBotID)
        XCTAssertEqual(synchroniseBot(from: newBot), newBot)
    }

    // MARK: - deleteBot

    func test_deleteBot_shouldCompleteWithTrue_whenNoBotID() {
        XCTAssert(deleteBot(from: newBot))
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

    @discardableResult func synchroniseBot(from bot: Bot) -> Bot {
        var result: Bot!
        syncer.synchronise(bot) { b in
            result = b
        }
        return result
    }

    func deleteBot(from bot: Bot) -> Bool {
        var result: Bool!
        syncer.delete(bot) { r in
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

    func stubValidDuplicateBotResponse(botID: String) {
        mockedDuplicateBotRequest.stubbedResponse = XCSResponse(data: botID, statusCode: 200)
    }

    func stubInvalidDuplicateBotResponse() {
        mockedDuplicateBotRequest.stubbedResponse = nil
    }

    func stubInvalidGetBotResponse() {
        mockedGetBotRequest.stubbedResponse = nil
    }

    func stubNotFoundGetBotResponse() {
        mockedGetBotRequest.stubbedResponses.append(XCSResponse(data: Data(), statusCode: 404))
    }

    func stubValidGetDuplicatedBotResponse() {
        stubValidGetBotResponse()
    }

    func stubValidGetBotResponse() {
        let file = testBundle.url(forResource: "bot_get_response", withExtension: "json")!
        let data = try! Data(contentsOf: file)
        mockedGetBotRequest.stubbedResponses.append(XCSResponse(data: data, statusCode: 200))
    }

    func stubDeleteBotResponse(statusCode: Int) {
        mockedDeleteBotRequest.stubbedResponse = XCSResponse(data: (), statusCode: statusCode)
    }

    func stubInvalidDeleteBotResponse() {
        mockedDeleteBotRequest.stubbedResponse = nil
    }

    func stubValidPatchBotResponse() {
        mockedPatchBotRequest.stubbedResponse = XCSResponse(data: (), statusCode: 200)
    }

    func botName(for bot: Bot) -> String {
        return "xcsautobuild [\(bot.branchName)]"
    }

    func branchName(fromBotDictionary dictionary: [String: Any]) -> String? {
        return FlexiJSON(dictionary: dictionary)["configuration"]["sourceControlBlueprint"]["DVTSourceControlWorkspaceBlueprintLocationsKey"][testPrimaryRepoKey]["DVTSourceControlBranchIdentifierKey"].string
    }
}
