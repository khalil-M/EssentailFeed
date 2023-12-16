//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by User on 15/12/2023.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    
    var requestedURL: URL?
    
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRquestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
