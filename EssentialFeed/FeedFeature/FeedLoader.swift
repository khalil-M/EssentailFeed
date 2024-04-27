//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by User on 14/12/2023.
//

import Foundation


public typealias  LoadFeedResult = Result<[FeedImage], Error>


public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
