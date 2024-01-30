//
//  SharedTestHelper.swift
//  EssentialFeedTests
//
//  Created by User on 31/01/2024.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    let url = URL(string: "https://any-url.com")!
    return url
}
