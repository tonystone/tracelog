//
//  TraceLogTests.swift
//  TraceLog
//
//  Created by Tony Stone on 11/1/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import XCTest
import TraceLog

class TraceLogTests_Swift : XCTestCase {
    
    override class func setUp() {
        TraceLog.initialize(logWriters: [ConsoleWriter()], environment: ["LOG_ALL": "TRACE4"])
    }
    
    func testLogError() {
        
        logError() {
            "Swift: " + #function
        }
    }
    
    func testLogWarning() {
        
        logWarning() {
            "Swift: " + #function
        }
    }

    func testLogInfo() {
        
        logInfo {
            "Swift: " + #function
        }
    }
    
    func testLogTrace() {
        
        logTrace {
            "Swift: " + #function
        }
    }
    
    func testLogTrace1() {
        
        logTrace(1) {
            "Swift: " + #function
        }
    }
    
    func testLogTrace2() {
        
        logTrace(2) {
            "Swift: " + #function
        }
    }
    
    func testLogTrace3() {
        
        logTrace(3) {
            "Swift: " + #function
        }
    }
    
    func testLogTrace4() {
        
        logTrace(4) {
            "Swift: " + #function
        }
    }    
}
