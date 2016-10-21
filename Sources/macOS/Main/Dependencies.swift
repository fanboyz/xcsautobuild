
import Foundation

class Dependencies {
    
    static let wildcardBranchFilter = WildcardBranchFilter(patternDataStore: filePatternDataStore)
    static let network = XCSHTTPRequestSender(configuration: XCSHTTPRequestSender.Configuration(baseURL: URL(string: "https://\(Configuration.xcsHostName):20343/api")!, username: Configuration.xcsUserName, password: Configuration.xcsPassword))
    
    static let api: ThreadedXcodeServerBotAPI = {
        return ThreadedXcodeServerBotAPI(api: XcodeServerBotAPI(
            getBotsRequest: AnyXCSRequest(XCSGetBotsRequest(network: network)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: network)),
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: network))
        ))
    }()
    
    static let botSynchroniser: XCSBotSynchroniser = {
        return XCSBotSynchroniser(
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: network)),
            duplicateBotRequest: AnyXCSRequest(XCSDuplicateBotRequest(network: network)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: network)),
            patchBotRequest: AnyXCSRequest(XCSPatchBotRequest(network: network)),
            botTemplateLoader: FileBotTemplateDataStore(file: Locations.botTemplateFile.path))
    }()

    static let filePatternDataStore: FilePatternDataStore = {
        return FilePatternDataStore(file: Locations.patternFile.path)
    }()
}
