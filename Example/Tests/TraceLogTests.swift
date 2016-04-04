//
//  TraceLogTests.swift
//  TraceLog
//
//  Created by Tony Stone on 11/1/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import XCTest
import TraceLog

internal class Testriter : NSObject, TLWriter {

    func log(date: NSTimeInterval, level: LogLevel, tag: String, message: String?, file: String, function: String, lineNumber: UInt) -> Void {
    }
}


class TraceLogTests: XCTestCase {
    
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
