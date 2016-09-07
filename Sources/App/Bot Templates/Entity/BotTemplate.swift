//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

struct BotTemplate: Equatable {
    let name: String
    let data: NSData
}

func ==(lhs: BotTemplate, rhs: BotTemplate) -> Bool {
    return lhs.name == rhs.name
        && lhs.data == rhs.data
}
