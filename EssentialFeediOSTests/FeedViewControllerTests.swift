//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by User on 18/09/2024.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController{
    private var loader: FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = FakeRefreshControll()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl?.beginRefreshing()
        load()
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
//        refreshControl?.beginRefreshing()
//        load()
//    }
    
    @objc private func load() {
        loader?.load { _ in}
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed () {
        let (_, loader) = makeSUT()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed () {
//        let loader = LoaderSpy ()
//        let sut = FeedViewController(loader: loader)
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 4)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 5)
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        
        //sut.beginAppearanceTransition(true, animated: false) // viewWillApear
        //sut.endAppearanceTransition() // viewIsAppearing+viewDidAppear
       
        sut.loadViewIfNeeded()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
        sut.refreshControl?.endRefreshing()
        sut.refreshControl?.sendActions(for: .valueChanged)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

class FakeRefreshControll: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = false
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

private extension FeedViewController {
    
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControll()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions (forTarget: target, forControlEvent: .valueChanged)?.forEach {
                action in
                fake.addTarget (target, action: Selector(action), for: .valueChanged)
            }
            refreshControl = fake
        }
    }
}
