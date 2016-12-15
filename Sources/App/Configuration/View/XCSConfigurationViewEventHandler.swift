
protocol XCSConfigurationViewEventHandler {
    func refresh()
    func didChangeHost(_ host: String)
    func didChangeUserName(_ userName: String)
    func didChangePassword(_ password: String)
}
