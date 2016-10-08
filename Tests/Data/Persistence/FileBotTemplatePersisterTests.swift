//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class FileBotTemplatePersisterTests: XCTestCase {
    
    var persister: FileBotTemplatePersister!
    var mockedDataWriter: MockDataWriter!
    var mockedDataLoader: MockDataLoader!
    let file = "test file"
    
    override func setUp() {
        super.setUp()
        mockedDataWriter = MockDataWriter()
        mockedDataLoader = MockDataLoader()
        persister = FileBotTemplatePersister(file: file, dataLoader: mockedDataLoader, dataWriter: mockedDataWriter)
    }
    
    // MARK: - save
    
    func test_save_shouldWriteTemplateJSONToFile() {
        let template = BotTemplate(name: "", data: Data())
        persister.save(template)
        XCTAssert(mockedDataWriter.didWriteToFile)
        XCTAssertEqual(mockedDataWriter.invokedPath, file)
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
