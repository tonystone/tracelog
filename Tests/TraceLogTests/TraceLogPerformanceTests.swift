///
///  TraceLogPerformanceTests.swift
///  TraceLog
///
///  Created by Tony Stone on 10/1/16.
///  Copyright © 2016 Tony Stone. All rights reserved.
///
import XCTest
import TraceLog

/// Test iteration count for all performance tests in this file
private let testIterations = 1000

class TraceLogPerformanceTestsSwift: XCTestCase {

    func testLogErrorPerformance() {

        /// Reset the logger to the default before testing
        TraceLog.configure(writers: [ConsoleWriter()], environment: ["LOG_ALL": "TRACE4"])

        self.measure {

            for _ in 0..<testIterations {
                logError { "Swift: " + #function }
            }
        }
    }

    func testLogTrace4Performance() {

        /// Reset the logger to the default before testing
        TraceLog.configure(writers: [ConsoleWriter()], environment: ["LOG_ALL": "TRACE4"])

        self.measure {

            for _ in 0..<testIterations {
                logTrace(1) { "Swift: " + #function }
            }
        }
    }

    func testLogErrorPerformance_NullWriter() {

        /// Remove the log writers for this test so we see the time it takes to process internally without io
        TraceLog.configure(writers: [], environment: ["LOG_ALL": "TRACE4"])

        self.measure {

            for _ in 0..<testIterations {
                logError { "Swift: " + #function }
            }
        }
    }

    func testLogTrace4Performance_NullWriter() {

        /// Remove the log writers for this test so we see the time it takes to process internally without io
        TraceLog.configure(writers: [], environment: ["LOG_ALL": "TRACE4"])

        self.measure {

            for _ in 0..<testIterations {
                logTrace(4) { "Swift: " + #function }
            }
        }
    }
}
