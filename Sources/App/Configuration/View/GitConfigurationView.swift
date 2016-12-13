import Foundation

protocol GitConfigurationView: class {
    func showDirectory(_ directory: URL)
    func showRemoteName(_ remoteName: String)
    func show(userName: String, password: String)
    func show(userName: String, password: String, publicKeyFile: URL, privateKeyFile: URL)
}
