///
///  AsyncWriterProxyTests.swift
///
///  Copyright 2018 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 12/14/18.
///
import XCTest
import TraceLogTestHarness

@testable import TraceLog

/// Test the AsyncWriterProxy functionality.
///
class AsyncWriterProxyTests: XCTestCase {

    /// Tag to use for all tests in this class.
    ///
    let testTag            = "Test Tag"
    let testStaticContext  = TestStaticContext()
    let testRuntimeContext = TestRuntimeContext()

    /// Simple test for a straight log write directly through to the Writer.
    ///
    /// This was should succeed almost instantly.
    ///
    func testLog() {

        let testMessage = "Test: " + testStaticContext.function
        let testWriter = ValidateExpectedValuesTestWriter(level: .error, tag:  self.testTag, message: testMessage, staticContext: self.testStaticContext)

        let proxy =  AsyncWriterProxy(writer: testWriter, options: [])

        // Test the log function of the proxy
        proxy.log(Date().timeIntervalSince1970, level: .error, tag: self.testTag, message: testMessage, runtimeContext: self.testRuntimeContext, staticContext: self.testStaticContext)

        self.wait(for: [testWriter.expectation], timeout: 2)
    }

    /// Test basic buffering to make sure that a single message
    /// when the writer is available writes to the Writer.
    ///
    func testLogWithBufferingWriterAvailable() {

        let testMessage = "Test: " + testStaticContext.function
        let testWriter = ValidateExpectedValuesTestWriter(level: .error, tag:  self.testTag, message: testMessage, staticContext: self.testStaticContext)

        let proxy =  AsyncWriterProxy(writer: testWriter, options: [.buffer(writeInterval: .seconds(60), strategy: .expand)])

        // Test the log function of the proxy
        proxy.log(Date().timeIntervalSince1970, level: .error, tag: self.testTag, message: testMessage, runtimeContext: self.testRuntimeContext, staticContext: self.testStaticContext)

        self.wait(for: [testWriter.expectation], timeout: 2)
    }

    /// Test buffering to make sure the proxy does not call the
    /// Writer when the Writer returns `false` for `available`.
    ///
    func testLogWithBufferingWriterUnavailable() {

        let testMessage = "Test: " + testStaticContext.function

        /// Start the writer unavailable
        let testWriter = ValidateExpectedValuesTestWriter(level: .error, tag:  self.testTag, message: testMessage, staticContext: self.testStaticContext, available: false)

        let proxy =  AsyncWriterProxy(writer: testWriter, options: [.buffer(writeInterval: .seconds(60), strategy: .expand)])

        // Test the log function of the proxy
        proxy.log(Date().timeIntervalSince1970, level: .error, tag: self.testTag, message: testMessage, runtimeContext: self.testRuntimeContext, staticContext: self.testStaticContext)

        /// This should time out because the proxy won't write the
        /// message to the writer until the writer is available
        ///
        /// Invert the expectation because we expect the expectation
        /// to timeout.
        ///
        testWriter.expectation.isInverted = true

        self.wait(for: [testWriter.expectation], timeout: 2)
    }

    /// Test buffering to make sure that the proxy buffers while
    /// the Writer returns `false` for `available` and then
    /// writes the message when it returns `true`.
    ///
    func testLogWithBufferingWriterDelayedAvailability() {

        let testEntries: [ValidateExpectedValuesTestWriter.ExpectedLogEntry] = (1...30).map { index in
            return (timestamp: Date().timeIntervalSince1970, level: .info, tag: self.testTag, message: "\(self.testStaticContext.function): test message #\(index)", runtimeContext: self.testRuntimeContext, staticContext: self.testStaticContext)
        }

        /// Start the writer unavailable
        let testWriter = ValidateExpectedValuesTestWriter(expected: testEntries, available: false)

        let proxy =  AsyncWriterProxy(writer: testWriter, options: [.buffer(writeInterval: .milliseconds(500), strategy: .expand)])

        // Test the log function of the proxy
        testEntries.forEach { (entry) in
            guard let timestamp      = entry.timestamp,
                  let runtimeContext = entry.runtimeContext,
                  let staticContext  = entry.staticContext
                else { XCTFail("Not all parameters supplied to test."); return }

            proxy.log(timestamp, level: entry.level, tag: entry.tag, message: entry.message, runtimeContext: runtimeContext, staticContext: staticContext)
        }

        /// Sleep for 2 seconds to make sure the proxy is buffering.
        sleep(2)

        /// At this point the writer should not have been called
        /// because the proxy is buffering.
        XCTAssertEqual(testWriter.resultCount, 0)

        /// Set the writer to available so the buffer is flushed.
        testWriter.available = true

        self.wait(for: [testWriter.expectation], timeout: 2)
    }

    /// Test that adding to a `.dropTail` buffer when it
    /// is full (at it's limit) drop the proper entries
    /// and no others.
    ///
    func testLogWithBufferingAndDropTailBufferLimitOverflow() {

        let testEntries: [ValidateExpectedValuesTestWriter.ExpectedLogEntry] = (1...30).map { index in
            return (timestamp: Date().timeIntervalSince1970, level: .info, tag: self.testTag, message: "\(self.testStaticContext.function): test message #\(index)", runtimeContext: self.testRuntimeContext, staticContext: self.testStaticContext)
        }
        let expectedEntries = Array(testEntries[0...14])

        /// Start the writer unavailable
        let testWriter = ValidateExpectedValuesTestWriter(expected: expectedEntries, available: false)

        let proxy =  AsyncWriterProxy(writer: testWriter, options: [.buffer(writeInterval: .milliseconds(500), strategy: .dropTail(at: 15))])

        // Test the log function of the proxy
        testEntries.forEach { (entry) in
            guard let timestamp      = entry.timestamp,
                  let runtimeContext = entry.runtimeContext,
                  let staticContext  = entry.staticContext
                else { XCTFail("Not all parameters supplied to test."); return }

            proxy.log(timestamp, level: entry.level, tag: entry.tag, message: entry.message, runtimeContext: runtimeContext, staticContext: staticContext)
        }

        /// Sleep for 2 seconds to make sure the proxy is buffering.
        sleep(2)

        /// At this point the writer should not have been called
        /// because the proxy is buffering.
        XCTAssertEqual(testWriter.resultCount, 0)

        /// Set the writer to available so the buffer is flushed.
        testWriter.available = true

        self.wait(for: [testWriter.expectation], timeout: 2)
    }

    /// Test that adding to a `.dropHead` buffer when it
    /// is full (at it's limit) drop the proper entries
    /// and no others.
    ///
    func testLogWithBufferingAndDropHeadBufferLimitOverflow() {

        let testEntries: [ValidateExpectedValuesTestWriter.ExpectedLogEntry] = (1...30).map { index in
            return (timestamp: Date().timeIntervalSince1970, level: .info, tag: self.testTag, message: "\(self.testStaticContext.function): test message #\(index)", runtimeContext: self.testRuntimeContext, staticContext: self.testStaticContext)
        }

        /// We only expect the last 15 since our buffer limit
        /// is set to 15 below.
        ///
        let expectedEntries = Array(testEntries[15...])

        /// Start the writer unavailable
        let testWriter = ValidateExpectedValuesTestWriter(expected: expectedEntries, available: false)

        let proxy =  AsyncWriterProxy(writer: testWriter, options: [.buffer(writeInterval: .milliseconds(500), strategy: .dropHead(at: 15))])

        // Test the log function of the proxy
        testEntries.forEach { (entry) in
            guard let timestamp      = entry.timestamp,
                  let runtimeContext = entry.runtimeContext,
                  let staticContext  = entry.staticContext
                else { XCTFail("Not all parameters supplied to test."); return }

            proxy.log(timestamp, level: entry.level, tag: entry.tag, message: entry.message, runtimeContext: runtimeContext, staticContext: staticContext)
        }

        /// Sleep for 2 seconds to make sure the proxy is buffering.
        sleep(2)

        /// At this point the writer should not have been called
        /// because the proxy is buffering.
        XCTAssertEqual(testWriter.resultCount, 0)

        /// Set the writer to available so the buffer is flushed.
        testWriter.available = true

        self.wait(for: [testWriter.expectation], timeout: 2)
    }
}
