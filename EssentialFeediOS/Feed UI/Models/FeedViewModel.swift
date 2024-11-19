//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by User on 17/11/2024.
//

import EssentialFeed
import UIKit

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    //since the viewModel manage the feedLoading state
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
//    private enum State {
//        case pending
//        case loading
//    }
    // viewModel can capture the state in private property and every time there is a state change
    // we notify the observer onChange closure
//    private var state = State.pending {
//        didSet { onChange?(self)}
//    }
    
    //normally using combine or RxSwift we can use a simple closure
//    var onChange: ((FeedViewModel) -> Void)?
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    //but since the state is private we need to expode access for the current state of the viewModel
    
//    private (set) var isLoading: Bool = false {
//        didSet { onChange?(self)}
//    }
    
    
    func loadFeed() {
        //define the state transition
//        state = .loading
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                //                self?.state = .loaded(feed)
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
            
        }
    }
}
