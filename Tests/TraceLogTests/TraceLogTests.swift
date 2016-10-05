//
//  TraceLogTests.swift
//  TraceLog
//
//  Created by Tony Stone on 11/1/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import XCTest
import TraceLog

///
/// Log Writer which captures the expected value and fulfills the XCTestExpectation when it matches the message
///
class ExpectationValues : Writer {
    
    let expectation: XCTestExpectation
    
    let level: LogLevel
    let tag: String
    let message: String
    let file: String
    let function: String
    
    init(expectation: XCTestExpectation, level: LogLevel, tag: String, message: String, file: String = #file, function: String = #function) {
        self.expectation = expectation
        self.level = level
        self.tag = tag
        self.message = message
        self.file = file
        self.function = function
    }
    
    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        
        if level == self.level &&
            tag == self.tag &&
            message == self.message &&
            staticContext.file == self.file &&
            staticContext.function == self.function
        {
            expectation.fulfill()
        }
    }
}

///
/// Main test class for Swift
///
class TraceLogTests_Swift : XCTestCase {
    
    let testTag = "Test Tag"
    
    func testinitialize_NoArgs() {
        TraceLog.initialize()
    }
    
    func testinitialize_LogWriters() {
        TraceLog.initialize(logWriters: [ConsoleWriter()])
    }
    
    func testinitialize_LogWriters_Environment() {
        TraceLog.initialize(logWriters: [ConsoleWriter()], environment: ["LOG_ALL": "TRACE4",
                                                                         "LOG_PREFIX_NS" : "OFF",
                                                                         "LOG_TAG_TraceLog" : "TRACE4"])
    }
    
    func testLogError() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .error, tag: testTag, message: testMessage)

        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "ERROR"])
        
        logError(testTag) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogWarning() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .warning, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "WARNING"])
        
        logWarning(testTag) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogInfo() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .info, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "INFO"])
        
        logInfo(testTag) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace1, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "TRACE1"])
        
        logTrace(testTag, level: 1) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace1() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace1, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "TRACE1"])
        
        logTrace(testTag, level: 1) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace2() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace2, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "TRACE2"])
        
        logTrace(testTag, level: 2) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace3() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace3, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "TRACE3"])
        
        logTrace(testTag, level: 3) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace4() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace4, tag: testTag, message: testMessage)
        
        TraceLog.initialize(logWriters: [expectedValues], environment: ["LOG_ALL": "TRACE4"])
        
        logTrace(testTag, level: 4) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }    
}
