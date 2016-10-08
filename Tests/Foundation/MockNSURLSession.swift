//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class MockNSURLSession: URLSession {
    
    var didCreateDataTask = false
    var stubbedData: Data?
    var stubbedResponse: URLResponse?
    var stubbedError: NSError?
    var stubbedDataTask = MockNSURLSessionDataTask()
    var invokedRequest: URLRequest?
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        didCreateDataTask = true
        invokedRequest = request
        completionHandler(stubbedData, stubbedResponse, stubbedError)
        return stubbedDataTask
    }
}
