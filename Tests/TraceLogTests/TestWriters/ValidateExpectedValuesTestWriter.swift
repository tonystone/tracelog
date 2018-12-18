///
///  ValidateExpectedValuesTestWriter.swift
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
///  Created by Tony Stone on 6/20/18.
///
import XCTest
import Foundation

import TraceLog

///
/// Log Writer which captures the expected value and fulfills the XCTestExpectation when it matches the message
///
class ValidateExpectedValuesTestWriter: Writer {

    /// The type supplied and stored as an expected log entry.
    ///
    typealias ExpectedLogEntry = (timestamp: Double?, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext?, staticContext: StaticContext?)

    /// Is this writer availabe for writing
    var available: Bool

    /// Total number of calls made to this
    /// Writer's log function that were not
    /// filtered out.
    ///
    var resultCount: Int

    /// List of tags to filter entries for.
    ///
    /// Note: all calls to log that has a tag that is
    ///       contained in this list will be dropped.
    ///
    let filterTags: [String]

    /// Ignore the StaticContext.line for comparison.
    ///
    var ignoreLineInComparison: Bool

    /// The XCTestExpectation created for this writer so
    /// the caller can wait until all asyn calls to the log
    /// function have completed.
    ///
    let expectation: XCTestExpectation

    /// The log entries that are expected to be logged to this writer.
    ///
    private let expected: [ExpectedLogEntry]

    /// Initializes an instance of 'Self'
    ///
    /// - Parameters:
    ///     - expected: An array of expected log entries each representing an expected call to this Writer's log function.
    ///     - filterTags: An array of tags that will be used to filter calls to this Writer's log function.  Any call with a tag that is contained in this list will be dropped.
    ///     - availabe: The initial state of availability this Wetiter should assume.
    ///
    init(expected: [ExpectedLogEntry], filterTags: [String] = [], available: Bool = true) {
        self.available = available
        self.resultCount = 0
        self.filterTags = filterTags
        self.ignoreLineInComparison = false
        self.expected = expected

        self.expectation = XCTestExpectation(description: "Write Expectation")

        /// We expect to get a call for each message in the buffer.
        self.expectation.expectedFulfillmentCount = expected.count

        /// to many messages would be an error as well.
        self.expectation.assertForOverFulfill = true
    }

    convenience init(timestamp: Double? = nil, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext? = nil, staticContext: StaticContext? = nil, filterTags: [String] = [],ignoreLine: Bool = true, available: Bool = true) {
        self.init(expected: [(timestamp: timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)], filterTags: filterTags, available: available)

        self.ignoreLineInComparison = ignoreLine
    }

    /// Required Writer.log function (required by the Writer protocol).
    ///
    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        /// Drop (Filter) any entries that are contained
        /// in our list of tags to filter.
        ///
        guard !filterTags.contains(tag)
            else { return }

        /// The index will be the resultCount before incrementing
        let index = self.resultCount

        self.resultCount += 1

        if resultCount <= expected.count {
            let expected = self.expected[index]

            /// Always required
            guard level == expected.level && tag == expected.tag && message == expected.message
                else {
                    let newEntry = (timestamp: timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)

                    XCTFail("\(newEntry) is not equal to: \(expected)"); return }

            /// Optional comparisons
            ///
            /// Note: Timestamps can not be compared when calling the high level
            ///       TraceLog functions due to the fact that TraceLog captures
            ///       the timestamp inside the logPrimitive function.
            ///
            if let expectedTimestamp = expected.timestamp {
                guard timestamp == expectedTimestamp
                    else { XCTFail("Timestamp \(timestamp) is not equal to: \(expectedTimestamp)"); return }
            }

            if let expectedRuntimeContext = expected.runtimeContext {
                guard runtimeContext.processIdentifier == expectedRuntimeContext.processIdentifier &&
                      runtimeContext.processName       == expectedRuntimeContext.processName &&
                      runtimeContext.threadIdentifier  == expectedRuntimeContext.threadIdentifier
                    else { XCTFail("\(runtimeContext) is not equal to: \(expectedRuntimeContext)"); return }
            }

            if let expectedStaticContext = expected.staticContext {
                guard staticContext.file     == expectedStaticContext.file &&
                      staticContext.function == expectedStaticContext.function
                    else { XCTFail("\(staticContext) is not equal to: \(expectedStaticContext)"); return }

                if !ignoreLineInComparison {
                    guard staticContext.line == expectedStaticContext.line
                        else { XCTFail("\(staticContext) is not equal to: \(expectedStaticContext)"); return }
                }
            }

            /// If it matches all required fields increment the fulfullment count
            self.expectation.fulfill()
        }
    }
}

