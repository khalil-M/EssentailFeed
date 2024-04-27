//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by User on 12/01/2024.
//

import Foundation

public enum CachedFeed {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    typealias RetrievalResult = Swift.Result<CachedFeed, Error>
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


