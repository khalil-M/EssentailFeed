//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by User on 29/03/2024.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {
    
    public init() {}
    
    public func retrieve(completion: @escaping RetrievalCompletions) {
        completion(.empty)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    
}
