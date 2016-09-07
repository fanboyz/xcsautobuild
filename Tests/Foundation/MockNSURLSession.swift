//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class MockNSURLSession: NSURLSession {
    
    var didCreateDataTask = false
    var stubbedData: NSData?
    var stubbedResponse: NSURLResponse?
    var stubbedError: NSError?
    var stubbedDataTask = MockNSURLSessionDataTask()
    var invokedRequest: NSURLRequest?
    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        didCreateDataTask = true
        invokedRequest = request
        completionHandler(stubbedData, stubbedResponse, stubbedError)
        return stubbedDataTask
    }
}
