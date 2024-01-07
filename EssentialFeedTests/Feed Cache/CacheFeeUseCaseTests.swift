//
//  CacheFeeUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by User on 07/01/2024.
//

import XCTest

class LocalFeedLoader {
    
    init(store: FeedStore) {
        
    }
}
class FeedStore {
   var deleteCachedFeedCallcount = 0
}
class CacheFeeUseCaseTests: XCTestCase {
    
    // 1 delete old cache
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallcount, 0)
    }
}
