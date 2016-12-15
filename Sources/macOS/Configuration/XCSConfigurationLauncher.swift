
class XCSConfigurationLauncher {

    func launch(view: XCSConfigurationForm) {
        let dataStore = Dependencies.xcsConfigurationDataStore
        let presenter = XCSConfigurationPresenter(dataStore: AnyDataStore(dataStore), view: view)
        view.eventHandler = presenter
    }
}
