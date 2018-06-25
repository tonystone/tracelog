///
///  TraceLogTests.swift
///  TraceLog
///
///  Created by Tony Stone on 11/1/15.
///  Copyright © 2015 Tony Stone. All rights reserved.
///

import XCTest
import Dispatch

import TraceLog

///
/// Main test class for Swift
///
class TraceLogTestsSwift: XCTestCase {

    let testTag = "Test Tag"

    // MARK: - Configuration

    func testConfigureWithNoArgs() {
        TraceLog.configure()
    }

    func testConfigureWithLogWriters() {
        let testMessage = "TraceLog Configured using: {\n\tglobal: {\n\n\t\tALL = INFO\n\t}\n}"

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .info, tag: "TraceLog", message: testMessage, testFileFunction: false)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "INFO"])

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testConfigureWithLogWritersAndEnvironment() {

        let testMessage = "TraceLog Configured using: {\n\ttags: {\n\n\t\tTraceLog = TRACE4\n\t}\n\tprefixes: {\n\n\t\tNS = ERROR\n\t}\n\tglobal: {\n\n\t\tALL = TRACE4\n\t}\n}"

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .info, tag: "TraceLog", message: testMessage, testFileFunction: false)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE4",
                                                                    "LOG_PREFIX_NS": "ERROR",
                                                                    "LOG_TAG_TraceLog": "TRACE4"])

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testConfigureWithLogWritersAndEnvironmentGlobalInvalidLogLevel() {

        let testMessage = "Variable \'LOG_ALL\' has an invalid logLevel of \'TRACE5\'. \'LOG_ALL\' will be set to INFO."

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .warning, tag: "TraceLog", message: testMessage, testFileFunction: false)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE5"])

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testConfigureWithLogWritersAndEnvironmentPrefixInvalidLogLevel() {

        let testMessage = "Variable \'LOG_PREFIX_NS\' has an invalid logLevel of \'TRACE5\'. \'LOG_PREFIX_NS\' will NOT be set."

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .warning, tag: "TraceLog", message: testMessage, testFileFunction: false)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_PREFIX_NS": "TRACE5"])

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testConfigureWithLogWritersAndEnvironmentTagInvalidLogLevel() {

        let testMessage = "Variable \'LOG_TAG_TRACELOG\' has an invalid logLevel of \'TRACE5\'. \'LOG_TAG_TRACELOG\' will NOT be set."

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .warning, tag: "TraceLog", message: testMessage, testFileFunction: false)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_TAG_TraceLog": "TRACE5"])

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    // MARK: ConcurrencyMode tests

    func testModeDirectIsSameThread() {
        let input: (thread: Thread, message: String) = (Thread.current, "Random test message.")

        let validatingWriter = CallbackTestWriter() { (timestamp, level, tag, message, runtimeContext, staticContext) -> Void in

            // We ignore all but the message that is equal to our input message to avoid TraceLogs startup messages
            if message == input.message {
                XCTAssertEqual(Thread.current, input.thread)
            }
        }

        TraceLog.configure(writers: [.direct(validatingWriter)], environment: ["LOG_ALL": "INFO"])

        logInfo { input.message }
    }

    // Note: it does not make sense to test Sync for same thread or different as there is no gaurentee it will be either.

    func testModeAsyncIsDifferentThread() {
        let semaphore = DispatchSemaphore(value: 0)
        let input: (thread: Thread, message: String) = (Thread.current, "Random test message.")

        let validatingWriter = CallbackTestWriter() { (timestamp, level, tag, message, runtimeContext, staticContext) -> Void in

            // We ignore all but the message that is equal to our input message to avoid TraceLogs startup messages
            if message == input.message {
                XCTAssertNotEqual(Thread.current, input.thread)

                semaphore.signal()
            }
        }

        /// Setup test with Writer
        TraceLog.configure(writers: [.async(validatingWriter)], environment: ["LOG_ALL": "INFO"])

        /// Run test.
        logInfo { input.message }

        /// Wait for the thread to return
        XCTAssertEqual(semaphore.wait(timeout: .now() + 0.1), .success)
    }

    func testModeSyncBlocks() {
        let input: (thread: Thread, message: String) = (Thread.current, "Random test message.")
        var logged: Bool = false

        let validatingWriter = CallbackTestWriter() { (timestamp, level, tag, message, runtimeContext, staticContext) -> Void in

            // We ignore all but the message that is equal to our input message to avoid TraceLogs startup messages
            if message == input.message {
                logged = true
            }
        }

        TraceLog.configure(writers: [.sync(validatingWriter)], environment: ["LOG_ALL": "INFO"])

        /// This should block until our writer is called.
        logInfo { input.message }

        XCTAssertEqual(logged, true) /// Not a difinitive test.
    }

    func testNoDeadLockDirectMode() {
        TraceLog.configure(writers: [.direct(SleepyTestWriter(sleepTime: 100))], environment: ["LOG_ALL": "INFO"])

        self._testNoDeadLock()
    }

    func testNoDeadLockSyncMode() {
        TraceLog.configure(writers: [.sync(SleepyTestWriter(sleepTime: 100))], environment: ["LOG_ALL": "INFO"])

        self._testNoDeadLock()
    }

    func testNoDeadLockAsyncMode() {
        TraceLog.configure(writers: [.async(SleepyTestWriter(sleepTime: 100))], environment: ["LOG_ALL": "INFO"])

        self._testNoDeadLock()
    }

    func _testNoDeadLock() {

        let queue   = DispatchQueue(label: "_testNoDeadLock.queue", attributes: .concurrent)
        let loggers = DispatchGroup()

        for _ in 0...20 {
            queue.async(group: loggers) {

                for _ in 0...1000 {
                    logInfo { "Random test message." }
                }
            }
        }
        XCTAssertEqual(loggers.wait(timeout: .now() + 60.0), .success)
    }

    // MARK: - Logging Methods

    func testLogError() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .error, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "ERROR"])

        logError(testTag) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogWarning() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .warning, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "WARNING"])

        logWarning(testTag) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogInfo() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .info, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "INFO"])

        logInfo(testTag) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogTrace() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .trace1, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE1"])

        logTrace(testTag, level: 1) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogTrace1() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .trace1, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE1"])

        logTrace(testTag, level: 1) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogTrace2() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .trace2, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE2"])

        logTrace(testTag, level: 2) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogTrace3() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .trace3, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE3"])

        logTrace(testTag, level: 3) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    func testLogTrace4() {
        let testMessage = "Swift: " + #function

        let expectedValues = ValidateExpectedValuesTestWriter(expectation: self.expectation(description: testMessage), level: .trace4, tag: testTag, message: testMessage)

        TraceLog.configure(writers: [expectedValues], environment: ["LOG_ALL": "TRACE4"])

        logTrace(testTag, level: 4) { testMessage }

        self.waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

    // MARK: - Logging Methods when level below log level.

    func testLogErrorWhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logError(testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogWarningWhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logWarning(testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogInfoWhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logInfo(testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogTraceWhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logTrace(testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogTrace1WhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logTrace(1, testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogTrace2WhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logTrace(2, testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogTrace3WhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logTrace(3, testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }

    func testLogTrace4WhileOff() {
        let testMessage = "Swift: " + #function
        let semaphore = DispatchSemaphore(value: 0)

        let writer = FailWhenFiredWriter(semaphore: semaphore)

        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "OFF"])

        logTrace(4, testTag) { testMessage }

        let result = semaphore.wait(wallTimeout: DispatchWallTime.now() + .seconds(1))

        /// Note: success in this case means the test failed because the semaphore was signaled by the call to log the message.
        if result == .success {
            XCTAssertNil("Log level was OFF but message was written anyway.")
        }
    }
}
