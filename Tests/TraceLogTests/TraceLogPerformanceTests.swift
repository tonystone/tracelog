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

    struct NullWriter: Writer {

        func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {
            return .success(0)
        }
    }

    func testLogErrorPerformance_NullWriter() {

        TraceLog.configure(writers: [.async(NullWriter())], environment: ["LOG_ALL": "TRACE4"])

        self.measure {
            for _ in 0..<testIterations {
                logError { "Swift: " + #function }
            }
        }
    }

    func testLogTrace4Performance_NullWriter() {

        /// Remove the log writers for this test so we see the time it takes to process internally without io
        TraceLog.configure(writers: [.async(NullWriter())], environment: ["LOG_ALL": "TRACE4"])

        self.measure {

            for _ in 0..<testIterations {
                logTrace(4) { "Swift: " + #function }
            }
        }
    }
}
