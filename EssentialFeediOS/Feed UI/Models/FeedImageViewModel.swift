//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by User on 19/11/2024.
//

import Foundation

struct FeedImageViewModel<Image> {
    
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
    
}
