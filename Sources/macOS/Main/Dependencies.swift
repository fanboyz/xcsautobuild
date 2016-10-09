
class Dependencies {
    
    static let wildcardBranchFilter = WildcardBranchFilter()
    
    /// TODO: put this into a configuration file
    static let network = NSURLSessionNetwork(configuration: NSURLSessionNetwork.Configuration(username: username, password: password))
    
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
            botTemplateLoader: FileBotTemplatePersister(file: Locations.botTemplateFile.path))
    }()
}
