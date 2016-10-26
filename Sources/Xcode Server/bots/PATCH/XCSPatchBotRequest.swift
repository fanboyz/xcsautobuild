
import Foundation

class XCSPatchBotRequest: XCSRequest {
    
    let requestSender: HTTPRequestSender
    
    init(requestSender: HTTPRequestSender) {
        self.requestSender = requestSender
    }
    
    func createRequest(_ data: PatchBotRequestData) -> HTTPRequest {
        return HTTPRequest(path: "/bots/\(data.id)?overwriteBlueprint=true", method: .patch, jsonBody: data.dictionary)
    }
    
    func parse(response data: Data) -> Void? {
        return ()
    }
}
