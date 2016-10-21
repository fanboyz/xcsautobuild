
import Foundation

protocol HTTPRequestSender {
    func send(_ request: HTTPRequest, completion: ((Data?, Int?) -> ())?)
}
