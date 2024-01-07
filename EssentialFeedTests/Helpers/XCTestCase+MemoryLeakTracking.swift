//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by User on 28/12/2023.
//

import XCTest


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath,
                                     line: UInt = #line) {
        addTeardownBlock { [ weak instance] in
            XCTAssertNil(instance, "Instance should have been dealloacated. Potential memory leak.", file: file, line: line)
        }
    }

}
