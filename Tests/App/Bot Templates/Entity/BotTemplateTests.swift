
import XCTest
@testable import xcsautobuild

class BotTemplateTests: XCTestCase {
    
    // MARK: - ==

    func test_shouldBeEqual_whenPropertiesAreEqual() {
        let template = BotTemplate(name: "name", data: testData)
        XCTAssertEqual(template, template)
    }

    func test_shouldNotBeEqual_whenNamesAreDifferent() {
        let template = BotTemplate(name: "name", data: testData)
        let expected = BotTemplate(name: "wrong", data: testData)
        XCTAssertNotEqual(template, expected)
    }

    func test_shouldNotBeEqual_whenDataIsDifferent() {
        let data = "wrong".data(using: String.Encoding.utf8)!
        let template = BotTemplate(name: "name", data: testData)
        let expected = BotTemplate(name: "name", data: data)
        XCTAssertNotEqual(template, expected)
    }
}
