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
/// Main test class for Swift
///
class TraceLogTests_Swift : XCTestCase {
    
    let testTag = "Test Tag"
    
    func testInitialize_NoArgs() {
        TraceLog.configure()
    }
    
    func testInitialize_LogWriters() {
        let testMessage = "TraceLog Configured using: {\n\tglobal: {\n\n\t\tALL = INFO\n\t}\n}"
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .info, tag: "TraceLog", message: testMessage, testFileFunction: false)
        
        TraceLog.configure(writers: [expectedValues])
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testInitialize_LogWriters_Environment() {

        let testMessage = "TraceLog Configured using: {\n\ttags: {\n\n\t\tTraceLog = TRACE4\n\t}\n\tprefixes: {\n\n\t\tNS = OFF\n\t}\n\tglobal: {\n\n\t\tALL = TRACE4\n\t}\n}"
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .info, tag: "TraceLog", message: testMessage, testFileFunction: false)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE4",
                                                                    "LOG_PREFIX_NS" : "OFF",
                                                                    "LOG_TAG_TraceLog" : "TRACE4"])
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testInitialize_LogWriters_Environment_GlobalInvalidLogLevel() {
        
        let testMessage = "Variable \'LOG_ALL\' has an invalid logLevel of \'TRACE5\'. \'LOG_ALL\' will be set to INFO."
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .warning, tag: "TraceLog", message: testMessage, testFileFunction: false)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE5"])
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testInitialize_LogWriters_Environment_PrefixInvalidLogLevel() {
        
        let testMessage = "Variable \'LOG_PREFIX_NS\' has an invalid logLevel of \'TRACE5\'. \'LOG_PREFIX_NS\' will NOT be set."
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .warning, tag: "TraceLog", message: testMessage, testFileFunction: false)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_PREFIX_NS": "TRACE5"])
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testInitialize_LogWriters_Environment_TagInvalidLogLevel() {
        
        let testMessage = "Variable \'LOG_TAG_TRACELOG\' has an invalid logLevel of \'TRACE5\'. \'LOG_TAG_TRACELOG\' will NOT be set."
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .warning, tag: "TraceLog", message: testMessage, testFileFunction: false)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_TAG_TraceLog": "TRACE5"])
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogError() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .error, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "ERROR"])
        
        logError(testTag) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogWarning() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .warning, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "WARNING"])
        
        logWarning(testTag) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogInfo() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .info, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "INFO"])
        
        logInfo(testTag) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace1, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE1"])
        
        logTrace(testTag, level: 1) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace1() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace1, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE1"])
        
        logTrace(testTag, level: 1) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace2() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace2, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE2"])
        
        logTrace(testTag, level: 2) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace3() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace3, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE3"])
        
        logTrace(testTag, level: 3) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLogTrace4() {
        let testMessage = "Swift: " + #function
        
        let expectedValues = ExpectationValues(expectation: self.expectation(description: testMessage), level: .trace4, tag: testTag, message: testMessage)
        
        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE4"])
        
        logTrace(testTag, level: 4) { testMessage }
        
        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }    
}
