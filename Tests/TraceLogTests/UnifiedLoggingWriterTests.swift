///
///  UnifiedLoggingWriterTests.swift
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
///  Created by Tony Stone on 5/31/18.
///
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)

import XCTest
@testable import TraceLog

import os.log

///
/// Direct Logging to the Logger
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
class UnifiedLoggingWriterTests: XCTestCase {

    let writer = UnifiedLoggingWriter()

    // MARK: - Log Level Conversation with default table

    func testConvertLogLevelForError() {
        XCTAssertEqual(writer.convertLogLevel(for: .error), OSLogType.error)
    }

    func testConvertLogLevelForWarning() {
        XCTAssertEqual(writer.convertLogLevel(for: .warning), OSLogType.default)
    }

    func testConvertLogLevelForInfo() {
        XCTAssertEqual(writer.convertLogLevel(for: .info), OSLogType.default)
    }

    func testConvertLogLevelForTrace1() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace1), OSLogType.debug)
    }

    func testConvertLogLevelForTrace2() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace2), OSLogType.debug)
    }

    func testConvertLogLevelForTrace3() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace3), OSLogType.debug)
    }

    func testConvertLogLevelForTrace4() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace4), OSLogType.debug)
    }

    // MARK: - Log Level Conversation with empty table

    func testConvertLogLvelErrorWithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .error), OSLogType.default)
    }

    func testConvertLogLvelWarningWithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .warning), OSLogType.default)
    }

    func testConvertLogLvelInfoWithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .info), OSLogType.default)
    }

    func testConvertLogLvelTrace1WithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .trace1), OSLogType.default)
    }

    func testConvertLogLvelTrace2WithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .trace2), OSLogType.default)
    }

    func testConvertLogLvelTrace3WithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .trace3), OSLogType.default)
    }

    func testConvertLogLvelTrace4WithEmptyConversionTable() {
        XCTAssertEqual(UnifiedLoggingWriter(logLevelConversion: [:]).convertLogLevel(for: .trace4), OSLogType.default)
    }

    // MARK: - Init method tests

    func testSybsystem() {
        let subsystem = "TestSubsystemIdentifier"

        _testLog(for: .error, TestStaticContext(), UnifiedLoggingWriter(subsystem: subsystem), subsystem) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    // MARK: - Direct calls to the writer with default conversion table.

    func testLogError() {
        _testLog(for: .error, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogWarning() {
        _testLog(for: .warning, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogInfo() {
        _testLog(for: .info, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace1() {
        _testLog(for: .trace1, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace2() {
        _testLog(for: .trace2, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace3() {
        _testLog(for: .trace3, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace4() {
        _testLog(for: .trace4, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }
}

///
/// Logging through TraceLog to the Logger
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
class TraceLogWithUnifiedLoggingWriterTests: XCTestCase {

    let writer = UnifiedLoggingWriter()

    override func setUp() {
        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "TRACE4"])
    }

    func testLogError() {
        _testLog(for: .error, TestStaticContext(), writer) { input, _ in

            logError(input.tag, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogWarning() {
        _testLog(for: .warning, TestStaticContext(), writer) { input, _ in

            logWarning(input.tag, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogInfo() {
        _testLog(for: .info, TestStaticContext(), writer) { input, _ in

            logInfo(input.tag, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace1() {
        _testLog(for: .trace1, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 1, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace2() {
        _testLog(for: .trace2, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 2, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace3() {
        _testLog(for: .trace3, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 3, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace4() {
        _testLog(for: .trace4, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 4, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }
}

///
/// Test wrapper function to execute log tests.
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
private func _testLog(for level: LogLevel, _ staticContext: TestStaticContext, _ writer: UnifiedLoggingWriter, _ subsystem: String? = nil, logBlock: ((timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: TestRuntimeContext, staticContext: TestStaticContext), UnifiedLoggingWriter) -> Void) {

    /// This is the time in microseconds since the epoch UTC to match the journals time stamps.
    let timestamp = Date().timeIntervalSince1970 * 1000.0

    let input = (timestamp: timestamp, level: level, tag:  "TestTag", message: "UnifiedLoggingWriter test .\(level) message at timestamp \(timestamp)", runtimeContext: TestRuntimeContext("TestProcess", 10, 100), staticContext: staticContext)

    let log = OSLog(subsystem: subsystem ?? input.runtimeContext.processName, category: input.tag)

    guard log.isEnabled(type: writer.convertLogLevel(for: input.level))
            else { XCTFail("Log not configured for test."); return }

    /// Write to the test writer
    logBlock(input, writer)

    validateLogEntry(for: input, writer: writer, subsystem: subsystem)
}

///
/// Validate that the log record is in the journal
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
private func validateLogEntry(for input: (timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: TestRuntimeContext, staticContext: TestStaticContext), writer: UnifiedLoggingWriter, subsystem: String?) {

    let log = OSLog(subsystem: subsystem ?? input.runtimeContext.processName, category: input.tag)

    guard log.isEnabled(type: writer.convertLogLevel(for: input.level))
            else { XCTFail("Log not configured for test."); return }

    let command = "log show --predicate 'eventMessage == \"\(input.message)\"' --info --debug --style json --last 1m"

    let data = shell(command)

    do {
        let objects = try JSONSerialization.jsonObject(with: data)

        guard let logEntries = objects as? [[String: Any]]
            else { XCTFail("Incorrect json object returned from parsing log show results, expected [[String: Any]] but got \(type(of: objects))."); return }

        /// Find the journal entry by message string (message string should be unique based on the string + timestamp).
        for jsonEntry in logEntries where jsonEntry["eventMessage"] as? String ?? "" == input.message {
            ///
            /// These should be all the fields we pass to systemd journal.
            ///
            assertValue(for: jsonEntry, key: "subsystem",   eqauls: subsystem ?? input.runtimeContext.processName)
            assertValue(for: jsonEntry, key: "messageType", eqauls: "\(writer.convertLogLevel(for: input.level))")
            assertValue(for: jsonEntry, key: "category",    eqauls: input.tag)

            return  /// If we found a match and compared it, we're done!
        }
        XCTFail("Log entry not found using command: \"\(command)\".")
    } catch {
        XCTFail("Could parse JSON \(String(data: data, encoding: .utf8) ?? "nil"), error: \(error)."); return
    }
}

private func assertValue(for jsonObject: [String: Any], key: String, eqauls expected: String) {
    let result = jsonObject[key] as? String ?? ""

    XCTAssertEqual(result, expected, "\(key) should be \"\(expected)\" but is equal to \"\(result)\".")
}

///
/// Helper to run the shell and return the output
///
private func shell(_ command: String) -> Data {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    return pipe.fileHandleForReading.readDataToEndOfFile()
}

///
/// StaticContext structure for tests which captures the context for each test func.
///
struct TestStaticContext: StaticContext {

    public let file: String
    public let function: String
    public let line: Int

    ///
    /// Init `self` capturing the static environment of the caller.
    ///
    init(_ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.file       = file
        self.function   = function
        self.line       = line
    }
}

///
/// RuntimeContext structure for tests.
///
struct TestRuntimeContext: RuntimeContext {

    public let processName: String
    public let processIdentifier: Int
    public let threadIdentifier: UInt64

    init(_ processName: String, _ processIdentifier: Int, _ threadIdentifier: UInt64) {
        let process  = ProcessInfo.processInfo
        self.processName = process.processName
        self.processIdentifier = Int(process.processIdentifier)
        self.threadIdentifier = threadIdentifier
    }
}

#endif
