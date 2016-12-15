import XCTest
@testable import xcsautobuild

class XCSConfigurationPresenterTests: XCTestCase {

    var presenter: XCSConfigurationPresenter!
    var mockedView: MockXCSConfigurationView!
    var mockedDataStore: MockDataStore<XCSConfiguration>!

    override func setUp() {
        super.setUp()
        mockedView = MockXCSConfigurationView()
        mockedDataStore = MockDataStore()
        presenter = XCSConfigurationPresenter(dataStore: AnyDataStore(mockedDataStore), view: mockedView)
    }

    // MARK: - refresh

    func test_refresh_shouldNotifyView() {
        mockedDataStore.stubbedData = XCSConfiguration(host: "test-host", userName: "username", password: "password")
        presenter.refresh()
        XCTAssertEqual(mockedView.invokedHost, "test-host")
        XCTAssertEqual(mockedView.invokedUserName, "username")
        XCTAssertEqual(mockedView.invokedPassword, "password")
    }

    // MARK: - didChangeHost

    func test_didChangeHost_shouldSaveConfiguration() {
        presenter.didChangeHost("test-host")
        XCTAssertEqual(mockedDataStore.invokedData, XCSConfiguration(host: "test-host", userName: "", password: ""))
    }

    // MARK: - didChangeUserName

    func test_didChangeUserName_shouldSaveConfiguration() {
        presenter.didChangeUserName("username")
        XCTAssertEqual(mockedDataStore.invokedData, XCSConfiguration(host: "", userName: "username", password: ""))
    }

    // MARK: - didChangePassword

    func test_didChangePassword_shouldSaveConfiguration() {
        presenter.didChangePassword("password")
        XCTAssertEqual(mockedDataStore.invokedData, XCSConfiguration(host: "", userName: "", password: "password"))
    }

    // MARK: - integration

    func test_shouldSaveMultipleFields() {
        presenter.didChangeHost("1")
        presenter.didChangeUserName("2")
        presenter.didChangePassword("3")
        XCTAssertEqual(mockedDataStore.invokedData, XCSConfiguration(host: "1", userName: "2", password: "3"))
    }
}
