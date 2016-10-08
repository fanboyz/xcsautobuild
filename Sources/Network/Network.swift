//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol Network {
    func send(_ request: HTTPRequest, completion: ((Data?, Int?) -> ())?)
}
