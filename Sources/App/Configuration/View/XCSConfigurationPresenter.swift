
class XCSConfigurationPresenter: XCSConfigurationViewEventHandler {

    private let view: XCSConfigurationView
    private let dataStore: AnyDataStore<XCSConfiguration>
    private var configuration = XCSConfiguration(host: "", userName: "", password: "")

    init(dataStore: AnyDataStore<XCSConfiguration>, view: XCSConfigurationView) {
        self.dataStore = dataStore
        self.view = view
    }

    func refresh() {
        if let configuration = dataStore.load() {
            view.showHost(configuration.host)
            view.showUserName(configuration.userName)
            view.showPassword(configuration.password)
        }
    }

    func didChangeHost(_ host: String) {
        configuration.host = host
        dataStore.save(configuration)
    }

    func didChangeUserName(_ userName: String) {
        configuration.userName = userName
        dataStore.save(configuration)
    }

    func didChangePassword(_ password: String) {
        configuration.password = password
        dataStore.save(configuration)
    }
}
