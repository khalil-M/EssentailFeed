//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by User on 14/12/2023.
//

import Foundation


public protocol FeedLoader {
    typealias  Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
