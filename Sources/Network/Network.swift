
import Foundation

protocol Network {
    func send(_ request: HTTPRequest, completion: ((Data?, Int?) -> ())?)
}
