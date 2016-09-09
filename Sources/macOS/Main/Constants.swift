//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class Constants {

    static let api: ThreadedXcodeServerBotAPI = {
        return ThreadedXcodeServerBotAPI(api: XcodeServerBotAPI(
            createBotRequest: AnyXCSRequest(XCSPostBotsRequest(network: network)),
            getBotsRequest: AnyXCSRequest(XCSGetBotsRequest(network: network)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: network)),
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: network)),
            botTemplateLoader: FileBotTemplatePersister(file: templateFile)
        ))
    }()
}
