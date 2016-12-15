import Foundation

protocol XCSConfigurationView: class {
    func showHost(_ host: String)
    func showUserName(_ userName: String)
    func showPassword(_ password: String)
}
