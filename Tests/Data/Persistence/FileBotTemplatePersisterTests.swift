//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class FileBotTemplatePersisterTests: XCTestCase {
    
    var persister: FileBotTemplatePersister!
    var mockedData: MockNSData!
    var mockedDataLoader: MockDataLoader!
    let file = "test file"
    
    override func setUp() {
        super.setUp()
        mockedData = MockNSData()
        mockedDataLoader = MockDataLoader()
        persister = FileBotTemplatePersister(file: file, dataLoader: mockedDataLoader)
    }
    
    // MARK: - save
    
    func test_save_shouldWriteTemplateJSONToFile() {
        let template = BotTemplate(name: "", data: mockedData)
        persister.save(template)
        XCTAssert(mockedData.didWriteToFile)
        XCTAssertEqual(mockedData.invokedAtomically, true)
        XCTAssertEqual(mockedData.invokedPath, file)
    }

    // MARK: - load

    func test_load_shouldReadTemplateFromFile() {
        mockedDataLoader.stubbedData = testBotTemplate.data
        XCTAssertEqual(persister.load(), testBotTemplate)
    }

    func test_load_shouldReturnNil_whenNoFile() {
        XCTAssertNil(persister.load())
    }

    func test_load_shouldReturnNil_whenNoBotNameInData() {
        mockedDataLoader.stubbedData = Data()
        XCTAssertNil(persister.load())
    }
}
