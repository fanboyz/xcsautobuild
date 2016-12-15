import Foundation

class GitConfigurationLauncher {

    func launch(view: TogglingGitConfigurationView) {
        let dataStore = AnyDataStore(Dependencies.gitConfigurationDataStore)
        let presenter = GitConfigurationPresenter(dataStore: dataStore, view: view)
        view.eventHandler = presenter
    }
}
