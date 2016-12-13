@testable import xcsautobuild
import Foundation

class MockGitConfigurationView: GitConfigurationView {

    var invokedDirectory: URL?
    func showDirectory(_ directory: URL) {
        invokedDirectory = directory
    }

    var invokedRemoteName: String?
    func showRemoteName(_ remoteName: String) {
        invokedRemoteName = remoteName
    }

    var invokedUserName: String?
    var invokedPassword: String?
    func show(userName: String, password: String) {
        invokedUserName = userName
        invokedPassword = password
    }

    var invokedPublicKeyFile: URL?
    var invokedPrivateKeyFile: URL?
    func show(userName: String, password: String, publicKeyFile: URL, privateKeyFile: URL) {
        invokedUserName = userName
        invokedPassword = password
        invokedPublicKeyFile = publicKeyFile
        invokedPrivateKeyFile = privateKeyFile
    }
}
