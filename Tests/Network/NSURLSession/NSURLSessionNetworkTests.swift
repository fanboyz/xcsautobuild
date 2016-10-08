//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class NSURLSessionNetworkTests: XCTestCase {
    
    var network: NSURLSessionNetwork!
    var mockedSession: MockNSURLSession!
    let encodedCredentials = "dXNlcm5hbWU6cGFzc3dvcmQ="
    let configuration = NSURLSessionNetwork.Configuration(username: "username", password: "password")
    
    override func setUp() {
        super.setUp()
        mockedSession = MockNSURLSession()
        network = NSURLSessionNetwork(session: mockedSession, configuration: configuration)
    }

    // MARK: - session

    func test_session_shouldSetDelegate() {
        network = NSURLSessionNetwork(configuration: configuration)
        XCTAssert(network.session.delegate === network.delegate)
    }
    
    // MARK: - sendRequest
    
    func test_sendRequest_shouldRunDataTask() {
        sendRequest()
        XCTAssert(mockedSession.didCreateDataTask)
        XCTAssert(mockedSession.stubbedDataTask.didResume)
    }

    func test_sendRequest_shouldCompleteWithNoData_whenNoData() {
        mockedSession.stubbedData = nil
        XCTAssertNil(sendRequest().data)
    }

    func test_sendRequest_shouldCompleteWithData() {
        mockedSession.stubbedData = testData
        XCTAssertEqual(sendRequest().data, testData)
    }

    func test_sendRequest_shouldSetHeaders() {
        sendRequest()
        let headers = mockedSession.invokedRequest?.allHTTPHeaderFields
        XCTAssertEqual(headers?["X-XCSClientVersion"], "5")
        XCTAssertEqual(headers?["Authorization"], "Basic \(encodedCredentials)")
        XCTAssertEqual(headers?["Content-Type"], "application/json")
    }

    func test_sendRequest_shouldSetHTTPMethod() {
        network.send(createPostRequest(), completion: nil)
        XCTAssertEqual(mockedSession.invokedRequest?.httpMethod, "POST")
        sendRequest()
        XCTAssertEqual(mockedSession.invokedRequest?.httpMethod, "GET")
    }

    func test_sendRequest_shouldSetBody_whenPOST() {
        network.send(createPostRequest(), completion: nil)
        XCTAssertEqual(mockedSession.invokedRequest?.httpBody, jsonData())
    }

    func test_sendRequest_shouldNotSetBody_whenGET() {
        network.send(createGetRequestWithJSON(), completion: nil)
        XCTAssertNil(mockedSession.invokedRequest?.httpBody)
    }

    func test_sendRequest_shouldSetURL() {
        sendRequest()
        XCTAssertEqual(mockedSession.invokedRequest?.url, testURL)
    }

    func test_sendRequest_shouldReturnNilStatusCode_whenResponseIsNil() {
        XCTAssertNil(sendRequest().statusCode)
    }

    func test_sendRequest_shouldReturnNilStatusCode_whenWrongType() {
        mockedSession.stubbedResponse = URLResponse(URL: testURL, MIMEType: nil, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertNil(sendRequest().statusCode)
    }

    // MARK: - Helpers

    func sendRequest() -> (data: Data?, statusCode: Int?) {
        var response: (Data?, Int?)!
        network.send(testRequest) { r in
            response = r
        }
        return response
    }

    func createPostRequest() -> HTTPRequest {
        return HTTPRequest(url: "", method: .post, jsonBody: json())
    }

    func createGetRequestWithJSON() -> HTTPRequest {
        return HTTPRequest(url: "", method: .get, jsonBody: json())
    }

    func json() -> [String: Any] {
        return [
            "hello": "world"
        ]
    }

    func jsonData() -> Data {
        return try! JSONSerialization.data(withJSONObject: json(), options: [])
    }
}
