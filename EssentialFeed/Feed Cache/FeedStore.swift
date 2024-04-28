//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by User on 12/01/2024.
//

import Foundation

//typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public struct CachedFeed {
//    case empty
//    case found(feed: [LocalFeedImage], timestamp: Date)
    public let feed: [LocalFeedImage]
    public let timestamp: Date
    
    public init(feed: [LocalFeedImage], timestamp: Date) {
        self.feed = feed
        self.timestamp = timestamp
    }
}

public protocol FeedStore {
    // for the operation that finish with no success type with success case of type Void
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InesrtionResult = Result<Void, Error>
    typealias InsertionCompletion = (InesrtionResult) -> Void
    
    typealias RetrievalResult = Swift.Result<CachedFeed?, Error>
    typealias RetrievalCompletions = (RetrievalResult) -> Void
    
    
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletions)
}


