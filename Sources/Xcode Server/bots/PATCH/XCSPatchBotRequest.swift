
import Foundation

class XCSPatchBotRequest: XCSRequest {
    
    let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func createRequest(_ data: PatchBotRequestData) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots/\(data.id)?overwriteBlueprint=true", method: .patch, jsonBody: data.dictionary)
    }
    
    func parse(response data: Data) -> Void? {
        return ()
    }
}
