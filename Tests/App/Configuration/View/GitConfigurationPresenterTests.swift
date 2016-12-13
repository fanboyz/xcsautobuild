import XCTest
@testable import xcsautobuild

class GitConfigurationPresenterTests: XCTestCase {

    var presenter: GitConfigurationPresenter!
    var mockedDataStore: MockDataStore<GitConfiguration>!
    var mockedView: MockGitConfigurationView!
    let remoteName = "origin"
    let configuration = GitConfiguration(directory: testFile, remoteName: "origin", credential: testCredential)

    override func setUp() {
        super.setUp()
        mockedDataStore = MockDataStore()
        mockedView = MockGitConfigurationView()
        presenter = GitConfigurationPresenter(dataStore: AnyDataStore(mockedDataStore), view: mockedView)
    }

    // MARK: - refresh

    func test_refresh_shouldSetDataOnView() {
        mockedDataStore.stubbedData = configuration
        presenter.refresh()
        XCTAssertEqual(mockedView.invokedRemoteName, remoteName)
        XCTAssertEqual(mockedView.invokedDirectory, testFile)
        XCTAssertEqual(mockedView.invokedUserName, "userName")
        XCTAssertEqual(mockedView.invokedPassword, "password")
    }

    func test_refresh_shouldSetSSHCredentialOnView() {
        var configuration = self.configuration
        configuration.credential = testSSHCredential
        mockedDataStore.stubbedData = configuration
        presenter.refresh()
        XCTAssertEqual(mockedView.invokedUserName, "userName")
        XCTAssertEqual(mockedView.invokedPassword, "password")
        XCTAssertEqual(mockedView.invokedPublicKeyFile, testFile)
        XCTAssertEqual(mockedView.invokedPrivateKeyFile, testFile)
    }

    func test_refresh_shouldStoreConfiguration() {
        mockedDataStore.stubbedData = configuration
        presenter.refresh()
        presenter.changedRemoteName("new")

        var expected = configuration
        expected.remoteName = "new"
        XCTAssertEqual(mockedDataStore.invokedData, expected)
    }

    // MARK: - changedDirectory

    func test_changedDirectory_shouldPersistGitConfiguration() {
        presenter.changedDirectory(testFile)
        let expected = GitConfiguration(directory: testFile, remoteName: "", credential: .http(userName: "", password: ""))
        XCTAssertEqual(mockedDataStore.invokedData, expected)
    }

    // MARK: - changedRemoteName

    func test_changedRemoteName_shouldPersistGitConfiguration() {
        presenter.changedRemoteName(remoteName)
        let expected = GitConfiguration(directory: URL(fileURLWithPath: ""), remoteName: remoteName, credential: .http(userName: "", password: ""))
        XCTAssertEqual(mockedDataStore.invokedData, expected)
    }

    // MARK: - changedCredential

    func test_changedCredential_shouldPersistGitConfiguration() {
        presenter.changedCredential(testCredential)
        let expected = GitConfiguration(directory: URL(fileURLWithPath: ""), remoteName: "", credential: testCredential)
        XCTAssertEqual(mockedDataStore.invokedData, expected)
    }

    // MARK: - integration

    func test_shouldPersistData() {
        presenter.changedDirectory(testFile)
        presenter.changedRemoteName(remoteName)
        presenter.changedCredential(testCredential)
        let expected = GitConfiguration(directory: testFile, remoteName: remoteName, credential: testCredential)
        XCTAssertEqual(mockedDataStore.invokedData, expected)
    }
}

