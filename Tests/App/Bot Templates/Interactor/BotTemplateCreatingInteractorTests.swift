
import XCTest
@testable import xcsautobuild

class BotTemplateCreatingInteractorTests: XCTestCase {
    
    var interactor: BotTemplateCreatingInteractor!
    var mockedBotTemplatesFetcher: MockBotTemplatesFetcher!
    var mockedBotTemplateDataStore: MockDataStore<BotTemplate>!
    var mockedOutput: MockBotTemplateCreatingInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockedBotTemplatesFetcher = MockBotTemplatesFetcher()
        mockedBotTemplateDataStore = MockDataStore()
        mockedOutput = MockBotTemplateCreatingInteractorOutput()
        interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: mockedBotTemplatesFetcher, botTemplateDataStore: AnyDataStore(mockedBotTemplateDataStore))
        interactor.output = mockedOutput
        interactor.botName = testBotTemplate.name
    }
    
    // MARK: - execute
    
    func test_execute_shouldFetchAvailableBots() {
        interactor.execute()
        XCTAssert(mockedBotTemplatesFetcher.didFetchBotTemplates)
    }

    func test_execute_shouldSaveBotTemplate_whenNamesMatch() {
        stubMatchingTemplate()
        interactor.execute()
        XCTAssert(mockedBotTemplateDataStore.didSave)
    }

    func test_execute_shouldNotSaveBotTemplate_whenNoTemplates() {
        stubNoTemplates()
        interactor.execute()
        XCTAssertFalse(mockedBotTemplateDataStore.didSave)
    }

    func test_execute_shouldNotSaveBotTemplate_whenNamesDoNotMatch() {
        stubNonMatchingTemplate()
        interactor.execute()
        XCTAssertFalse(mockedBotTemplateDataStore.didSave)
    }

    func test_execute_shouldNotifyOutput_whenNoTemplates() {
        stubNoTemplates()
        interactor.execute()
        XCTAssert(mockedOutput.didCallDidFailToFindTemplate)
    }

    func test_execute_shouldNotifyOutput_whenNamesDoNotMatch() {
        stubNonMatchingTemplate()
        interactor.execute()
        XCTAssert(mockedOutput.didCallDidFailToFindTemplate)
    }

    func test_execute_shouldNotifyOutput_whenSavingTemplate() {
        stubMatchingTemplate()
        interactor.execute()
        XCTAssert(mockedOutput.didCallDidCreateTemplate)
    }

    // MARK: - Helpers

    func stubMatchingTemplate() {
        mockedBotTemplatesFetcher.stubbedBotTemplates = [testBotTemplate]
    }

    func stubNoTemplates() {
        mockedBotTemplatesFetcher.stubbedBotTemplates = []
    }

    func stubNonMatchingTemplate() {
        let template = BotTemplate(name: "nonmatching", data: Data())
        mockedBotTemplatesFetcher.stubbedBotTemplates = [template]
    }
}
