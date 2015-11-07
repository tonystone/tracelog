//
//  TraceLogTests.swift
//  TraceLog
//
//  Created by Tony Stone on 11/1/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import XCTest
import TraceLog


class TraceLogTests: XCTestCase {
    
    func testError() {
        
        logError() {
            "Swift: " + __FUNCTION__
        }
    }
    
    func testWarning() {
        
        logWarning() {
            "Swift: " + __FUNCTION__
        }
    }

    func testInfo() {
        
        logInfo {
            "Swift: " + __FUNCTION__
        }
    }
    
    func testTrace() {
        
        logTrace {
            "Swift: " + __FUNCTION__
        }
    }
    
    func testTrace1() {
        
        logTrace(1) {
            "Swift: " + __FUNCTION__
        }
    }
    
    func testTrace2() {
        
        logTrace(2) {
            "Swift: " + __FUNCTION__
        }
    }
    
    func testTrace3() {
        
        logTrace(3) {
            "Swift: " + __FUNCTION__
        }
    }
    
    func testTrace4() {
        
        logTrace(4) {
            "Swift: " + __FUNCTION__
        }
    }
    
}
