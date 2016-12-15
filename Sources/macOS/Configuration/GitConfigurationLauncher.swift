import Foundation

class GitConfigurationLauncher {

    func launch(view: GitConfigurationForm) {
        let dataStore = Dependencies.gitConfigurationDataStore
        let presenter = GitConfigurationPresenter(dataStore: dataStore, view: view)
        view.eventHandler = presenter
    }
}
