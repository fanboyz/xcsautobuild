//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct HTTPRequest: Equatable {
    var path: String
    var method: HTTPMethod
    var jsonBody: [String: Any]?
}

func ==(lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
    return lhs.path == rhs.path
        && lhs.method == rhs.method
        && lhs.jsonBody as NSDictionary? == rhs.jsonBody as NSDictionary?
}
