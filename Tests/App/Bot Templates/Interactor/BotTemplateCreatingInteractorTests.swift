//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class BotTemplateCreatingInteractorTests: XCTestCase {
    
    var interactor: BotTemplateCreatingInteractor!
    var mockedBotTemplatesFetcher: MockBotTemplatesFetcher!
    var mockedBotTemplateSaver: MockBotTemplateSaver!
    var mockedOutput: MockBotTemplateCreatingInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockedBotTemplatesFetcher = MockBotTemplatesFetcher()
        mockedBotTemplateSaver = MockBotTemplateSaver()
        mockedOutput = MockBotTemplateCreatingInteractorOutput()
        interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: mockedBotTemplatesFetcher, botTemplateSaver: mockedBotTemplateSaver)
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
        XCTAssert(mockedBotTemplateSaver.didSave)
    }

    func test_execute_shouldNotSaveBotTemplate_whenNoTemplates() {
        stubNoTemplates()
        interactor.execute()
        XCTAssertFalse(mockedBotTemplateSaver.didSave)
    }

    func test_execute_shouldNotSaveBotTemplate_whenNamesDoNotMatch() {
        stubNonMatchingTemplate()
        interactor.execute()
        XCTAssertFalse(mockedBotTemplateSaver.didSave)
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
