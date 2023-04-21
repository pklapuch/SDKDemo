//
//  XCTestCase+MemoryLeakTracking.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import XCTest

extension XCTestCase {
    func trackForMmeoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
