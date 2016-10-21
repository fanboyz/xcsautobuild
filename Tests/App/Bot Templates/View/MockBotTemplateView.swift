
import XCTest
@testable import xcsautobuild

class MockBotTemplateView: BotTemplateView {
    
    var didShowSuccess = false
    func showSuccess() {
        didShowSuccess = true
    }

    var didShowFailure = false
    func showFailure() {
        didShowFailure = true
    }
}
