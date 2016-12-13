import Foundation

class GitConfigurationPresenter: GitConfigurationViewEventHandler {

    private let dataStore: AnyDataStore<GitConfiguration>
    private weak var view: GitConfigurationView?
    private var configuration = GitConfiguration(directory: URL(fileURLWithPath: ""), remoteName: "", credential: .http(userName: "", password: ""))

    init(dataStore: AnyDataStore<GitConfiguration>, view: GitConfigurationView) {
        self.dataStore = dataStore
        self.view = view
    }

    func refresh() {
        guard let configuration = dataStore.load() else { return }
        self.configuration = configuration
        view?.showDirectory(configuration.directory)
        view?.showRemoteName(configuration.remoteName)
        show(credential: configuration.credential)
    }

    func changedDirectory(_ directory: URL) {
        configuration.directory = directory
        dataStore.save(configuration)
    }

    func changedRemoteName(_ remoteName: String) {
        configuration.remoteName = remoteName
        dataStore.save(configuration)
    }

    func changedCredential(_ credential: GitConfiguration.Credential) {
        configuration.credential = credential
        dataStore.save(configuration)
    }

    private func show(credential: GitConfiguration.Credential) {
        switch credential {
        case let .http(userName, password):
            view?.show(userName: userName, password: password)
        case let .ssh(userName, password, publicKeyFile, privateKeyFile):
            view?.show(userName: userName, password: password, publicKeyFile: publicKeyFile, privateKeyFile: privateKeyFile)
        }
    }
}
