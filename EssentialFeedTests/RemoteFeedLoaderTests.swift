//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by User on 15/12/2023.
//

import XCTest

class RemoteFeedLoader {
    
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
    
}

class HTTPClient {
    
    static let shared = HTTPClient()
    private init() {}
    
    var requestedURL: URL?
    
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRquestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    
    // load item command
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
