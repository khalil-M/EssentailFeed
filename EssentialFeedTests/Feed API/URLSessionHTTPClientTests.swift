//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by User on 25/12/2023.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in}
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSPy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    //MARK: - Helpers
    
    private class URLSessionSPy: URLSession {
        var receivedURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        
    }
}
