//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BotsFetcher {
    func getBots(_ completion: (([RemoteBot]) -> ()))
}
