//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class Constants {

    static let api: ThreadedXcodeServerBotAPI = {
        return ThreadedXcodeServerBotAPI(api: XcodeServerBotAPI(
            getBotsRequest: AnyXCSRequest(XCSGetBotsRequest(network: Constants.network)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: Constants.network)),
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: Constants.network))
        ))
    }()
}
