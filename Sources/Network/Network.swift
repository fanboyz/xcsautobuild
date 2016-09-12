//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol Network {
    func send(request: HTTPRequest, completion: ((NSData?, Int?) -> ())?)
}
