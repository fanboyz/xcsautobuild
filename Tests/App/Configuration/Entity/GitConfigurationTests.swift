import XCTest
import ObjectiveGit
@testable import xcsautobuild


class GitConfigurationTests: XCTestCase {

    // MARK: - ==

    func test_shouldBeEqual_whenPropertiesAreEqual() {
        XCTAssert(isEqual())
    }

    func test_shouldNotBeEqual_whenDirectoriesAreNotEqual() {
        XCTAssertFalse(isEqual(directory: URL(fileURLWithPath: "different")))
    }

    func test_shouldNotBeEqual_whenRemoteNamesAreNotEqual() {
        XCTAssertFalse(isEqual(remoteName: "different"))
    }

    func test_shouldNotBeEqual_whenCredentialsAreNotEqual() {
        XCTAssertFalse(isEqual(credential: testSSHCredential))
    }

    // MARK: - Helpers

    func isEqual(
        directory: URL = testFile,
        remoteName: String = "origin",
        credential: GitConfiguration.Credential = testCredential
    ) -> Bool {
        let configuration = GitConfiguration(directory: testFile, remoteName: "origin", credential: testCredential)
        let other = GitConfiguration(directory: directory, remoteName: remoteName, credential: credential)
        return configuration == other
    }
}

class GitConfiguration_CredentialTests: XCTestCase {

    // MARK: - ==

    func test_shouldBeEqual_whenPropertiesAreEqual() {
        XCTAssert(isHTTPEqual())
        XCTAssert(isSSHEqual())
    }

    func test_shouldNotBeEqual_whenUserPassTypesAreNotEqual() {
        XCTAssertFalse(isHTTPEqual(userName: "different"))
        XCTAssertFalse(isHTTPEqual(password: "different"))
    }

    func test_shouldNotBeEqual_whenUserSSHTypesAreNotEqual() {
        XCTAssertFalse(isSSHEqual(userName: "different"))
        XCTAssertFalse(isSSHEqual(password: "different"))
        XCTAssertFalse(isSSHEqual(publicKeyFile: URL(fileURLWithPath: "different")))
        XCTAssertFalse(isSSHEqual(privateKeyFile: URL(fileURLWithPath: "different")))
    }

    func test_shouldNotBeEqual_whenTypesAreDifferent() {
        XCTAssertNotEqual(testCredential, testSSHCredential)
    }

    // MARK: - Helpers

    func isHTTPEqual(
        userName: String = "userName",
        password: String = "password"
    ) -> Bool {
        let credential = GitConfiguration.Credential.http(userName: userName, password: password)
        let other = GitConfiguration.Credential.http(userName: "userName", password: "password")
        return credential == other
    }

    func isSSHEqual(
        userName: String = "userName",
        password: String = "password",
        publicKeyFile: URL = testFile,
        privateKeyFile: URL = testFile
    ) -> Bool {
        let credential = GitConfiguration.Credential.ssh(userName: userName, password: password, publicKeyFile: publicKeyFile, privateKeyFile: privateKeyFile)
        let other = GitConfiguration.Credential.ssh(userName: "userName", password: "password", publicKeyFile: testFile, privateKeyFile: testFile)
        return credential == other
    }
}
