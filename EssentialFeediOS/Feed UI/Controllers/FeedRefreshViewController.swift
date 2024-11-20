//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by User on 16/11/2024.
//

import UIKit 

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    
    // since the controller needs the presenter to invoke loadFeed method
    // we can just pass an abstract interface instead of reference to the presenter
    // by passing closure handler
    
    
//    private let feedLoader: FeedLoader
    private let loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    

    @objc func refresh() {
        loadFeed()
    }
    
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
