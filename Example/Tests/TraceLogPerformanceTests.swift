//
//  TraceLogPerformanceTests.swift
//  TraceLog
//
//  Created by Tony Stone on 10/1/16.
//  Copyright © 2016 Tony Stone. All rights reserved.
//
import XCTest
import TraceLog

/// Test iteration count for all performance tests in this file
private let testIterations = 10000

class TraceLogPerformanceTests_Swift : XCTestCase {
    
    func testLogError_Performance() {
        
        // Reset the logger to the default before testing
        TLLogger.setWriters([TLConsoleWriter()])
        
        self.measureBlock {
            
            for _ in 0..<testIterations {
                logError { "Swift: " + #function }
            }
        }
    }
    
    func testLogTrace4_Performance() {
        
        // Reset the logger to the default before testing
        TLLogger.setWriters([TLConsoleWriter()])
        
        self.measureBlock {
            
            for _ in 0..<testIterations {
                logTrace(1) { "Swift: " + #function }
            }
        }
    }
    
    func testLogError_Performance_NullWriter() {
        
        /// Remove the log writers for this test so we see the time it takes to process internally without io
        TLLogger.setWriters([])
        
        self.measureBlock {
            
            for _ in 0..<testIterations {
                logError { "Swift: " + #function }
            }
        }
    }
    
    func testLogTrace4_Performance_NullWriter() {
        
        /// Remove the log writers for this test so we see the time it takes to process internally without io
        TLLogger.setWriters([])
        
        self.measureBlock {
            
            for _ in 0..<testIterations {
                logTrace(4) { "Swift: " + #function }
            }
        }
    }
    
}
