
import Foundation

class XCSPatchBotRequest: XCSRequest {
    
    let network: HTTPRequestSender
    
    init(network: HTTPRequestSender) {
        self.network = network
    }
    
    func createRequest(_ data: PatchBotRequestData) -> HTTPRequest {
        return HTTPRequest(path: "/bots/\(data.id)?overwriteBlueprint=true", method: .patch, jsonBody: data.dictionary)
    }
    
    func parse(response data: Data) -> Void? {
        return ()
    }
}
