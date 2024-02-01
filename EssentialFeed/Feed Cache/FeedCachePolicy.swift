//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by User on 01/02/2024.
//

import Foundation

enum FeedCachePolicy {
    
    
    private static let calender = Calendar(identifier: .gregorian)
    
    
    
    private static var maxCachedAgeIndays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, agains date: Date) -> Bool {
        guard let maxCacheAge = calender.date(byAdding: .day, value: maxCachedAgeIndays, to: timestamp) else { return  false }
        return date < maxCacheAge
    }
}
