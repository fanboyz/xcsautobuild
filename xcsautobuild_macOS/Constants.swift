//
//  Constants.swift
//
//
//

import Foundation

class Constants {

    static let api: XcodeServerBotAPI = {
        return XcodeServerBotAPI(
            createBotRequest: AnyXCSRequest(XCSPostBotsRequest(network: network)),
            getBotsRequest: AnyXCSRequest(XCSGetBotsRequest(network: network)),
            deleteBotRequest: AnyXCSRequest(XCSDeleteBotRequest(network: network)),
            getBotRequest:  AnyXCSRequest(XCSGetBotRequest(network: network))
        )
    }()
}
