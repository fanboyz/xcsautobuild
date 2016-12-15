import Foundation
@testable import xcsautobuild

class MockXCSConfigurationView: XCSConfigurationView {

    var invokedHost: String?
    func showHost(_ host: String) {
        invokedHost = host
    }

    var invokedUserName: String?
    func showUserName(_ userName: String) {
        invokedUserName = userName
    }

    var invokedPassword: String?
    func showPassword(_ password: String) {
        invokedPassword = password
    }
}
