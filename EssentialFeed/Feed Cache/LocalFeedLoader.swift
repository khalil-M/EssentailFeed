//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by User on 12/01/2024.
//

import Foundation

public final class LocalFeedLoader {
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deledCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionerror = error {
                completion(cacheDeletionerror)
            } else {
                self.cache(items, completion: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], completion: @escaping(SaveResult) -> Void) {
        store.insert(items, timestamp: currentDate(), completion: { [weak self] error in
            guard let self = self else { return }
            completion(error)
        })
    }
}


