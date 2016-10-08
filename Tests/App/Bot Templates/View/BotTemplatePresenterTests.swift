//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class BotTemplatePresenterTests: XCTestCase {
    
    var presenter: BotTemplatePresenter!
    var mockedView: MockBotTemplateView!
    var mockedTemplateCreatingInteractor: MockTemplateCreatingInteractor!
    let testName = "name"
    
    override func setUp() {
        super.setUp()
        mockedView = MockBotTemplateView()
        mockedTemplateCreatingInteractor = MockTemplateCreatingInteractor()
        presenter = BotTemplatePresenter(view: mockedView, templateCreatingInteractor: mockedTemplateCreatingInteractor)
    }

    // MARK: - create(templateFromName:)

    func test_createTemplateFromName_shouldSetBotNameOnInteractor() {
        createTemplateFromName()
        XCTAssertEqual(mockedTemplateCreatingInteractor.botName, testName)
    }

    func test_createTemplateFromName_shouldExecuteInteractor() {
        createTemplateFromName()
        XCTAssert(mockedTemplateCreatingInteractor.didExecute)
    }

    // MARK: - didCreateTemplate

    func test_didCreateTemplate_shouldNotifyView() {
        presenter.didCreateTemplate()
        XCTAssert(mockedView.didShowSuccess)
    }

    // MARK: - didFailToFindTemplate

    func test_didFailToFindTemplate_shouldNotifyView() {
        presenter.didFailToFindTemplate()
        XCTAssert(mockedView.didShowFailure)
    }

    // MARK: - Helpers

    func createTemplateFromName() {
        presenter.createTemplate(fromName: testName)
    }
}
