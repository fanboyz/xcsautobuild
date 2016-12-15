
import Foundation

class Dependencies {

    static let filePatternDataStore = AnyDataStore(FilePatternDataStore(file: Locations.patternFile.path))
    static let xcsConfigurationDataStore = PlistXCSConfigurationDataStore(file: Locations.xcsConfigurationFile)
    static let gitConfigurationDataStore = PlistGitConfigurationDataStore(file: Locations.gitConfigurationFile)
    static let synchronisedBotsDataStore = PlistBotDataStore(file: Locations.synchronisedBotsFile.path)
    static let wildcardBranchFilter = WildcardBranchFilter(patternDataStore: filePatternDataStore)

    static func createRequestSender(xcsConfiguration: XCSConfiguration) -> XCSHTTPRequestSender {
        let configuration = XCSHTTPRequestSender.Configuration(
            baseURL: URL(string: "https://\(xcsConfiguration.host):20343/api")!,
            username: xcsConfiguration.userName,
            password: xcsConfiguration.password
        )
        return XCSHTTPRequestSender(configuration: configuration)
    }
    
    static func createAPI(requestSender: HTTPRequestSender) -> ThreadedXcodeServerBotAPI {
        return ThreadedXcodeServerBotAPI(api: XcodeServerBotAPI(
            getBotsRequest: AnyXCSRequest(XCSGetBotsRequest(requestSender: requestSender)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(requestSender: requestSender)),
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(requestSender: requestSender))
        ))
    }
    
    static func botSynchroniser(requestSender: HTTPRequestSender) -> XCSBotSynchroniser {
        return XCSBotSynchroniser(
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(requestSender: requestSender)),
            duplicateBotRequest: AnyXCSRequest(XCSDuplicateBotRequest(requestSender: requestSender)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(requestSender: requestSender)),
            patchBotRequest: AnyXCSRequest(XCSPatchBotRequest(requestSender: requestSender)),
            botTemplateLoader: FileBotTemplateDataStore(file: Locations.botTemplateFile.path)
        )
    }
}
