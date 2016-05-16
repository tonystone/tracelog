//
//  TraceLogTests.swift
//  TraceLog
//
//  Created by Tony Stone on 11/1/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import XCTest
import TraceLog

//
//internal class TestWriter : Writer {
//    func log(timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
//        print(message)
//    }
//}


class TraceLogTests_Swift : XCTestCase {
    
    override class func setUp() {
//        TraceLog.initialize(environment: ["LOG_ALL": "TRACE4"])
    }
    
    func testError() {
        
        logError() {
            "Swift: " + #function
        }
    }
    
    func testWarning() {
        
        logWarning() {
            "Swift: " + #function
        }
    }

    func testInfo() {
        
        logInfo {
            "Swift: " + #function
        }
    }
    
    func testTrace() {
        
        logTrace {
            "Swift: " + #function
        }
    }
    
    func testTrace1() {
        
        logTrace(1) {
            "Swift: " + #function
        }
    }
    
    func testTrace2() {
        
        logTrace(2) {
            "Swift: " + #function
        }
    }
    
    func testTrace3() {
        
        logTrace(3) {
            "Swift: " + #function
        }
    }
    
    func testTrace4() {
        
        logTrace(4) {
            "Swift: " + #function
        }
    }    
}
