///
///  ConsoleWriterTests.swift
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
///  Created by Tony Stone on 9/9/18.
///
import XCTest
import TraceLogTestHarness

@testable import TraceLog

private let testDirectory = "ConsoleWriterTestsTmp"

private let testEqual: (ConsoleWriter, TestLogEntry?, TestLogEntry) -> Void = { writer, result, expected in

    guard let result = result
        else { XCTFail("Failed to locate log entry."); return }

    XCTAssertEqual(result.timestamp ?? -1.0, expected.timestamp ?? -2.0, accuracy: 0.01)
    XCTAssertEqual(result.level,             expected.level)
    XCTAssertEqual(result.message,           expected.message)
    XCTAssertEqual(result.tag,               expected.tag)
    XCTAssertEqual(result.processName,       expected.processName)
    XCTAssertEqual(result.processIdentifier, expected.processIdentifier)
    XCTAssertEqual(result.threadIdentifier,  expected.threadIdentifier)
}

///
/// Direct Logging to the Logger
///
class ConsoleWriterTests: XCTestCase {

    override func setUp() {
        do {
            /// Create the test directory
            try FileManager.default.createDirectory(atPath: testDirectory, withIntermediateDirectories: false)
        } catch {
            XCTFail("Failed to cleanup log files before test: \(error).")
        }
    }

    override func tearDown() {
        do {
            try FileManager.default.removeItem(atPath: testDirectory)
        } catch {
            XCTFail("Failed to cleanup log files before test: \(error).")
        }
    }

    // MARK: - Direct calls to the writer with default date formatter.

    func testLogError() {
        testHarness(for: type(of: self))?.testLog(for: .error, validationBlock: testEqual)
    }

    func testLogWarning() {
        testHarness(for: type(of: self))?.testLog(for: .warning, validationBlock: testEqual)
    }

    func testLogInfo() {
        testHarness(for: type(of: self))?.testLog(for: .info, validationBlock: testEqual)
    }

    func testLogTrace1() {
        testHarness(for: type(of: self))?.testLog(for: .trace1, validationBlock: testEqual)
    }

    func testLogTrace2() {
        testHarness(for: type(of: self))?.testLog(for: .trace2, validationBlock: testEqual)
    }

    func testLogTrace3() {
        testHarness(for: type(of: self))?.testLog(for: .trace3, validationBlock: testEqual)
    }

    func testLogTrace4() {
        testHarness(for: type(of: self))?.testLog(for: .trace4, validationBlock: testEqual)
    }
}

///
/// Creates a TestHarness for the specific test class.
///
private func testHarness<T>(for callerType: T.Type, configureTraceLog: Bool = false, directory: String = testDirectory, function: String = #function) -> TestHarness<ConsoleWriterReader>? {

    let type    = String(describing: callerType)
    let function = function.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

    let fileName  = "\(type).\(function).log"
    let url = URL(fileURLWithPath: directory).appendingPathComponent(fileName)

    let outputStream: FileOutputStream
    do {
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: url.path) {

            ///
            /// Create the directory if it does not exist.
            ///
            /// Note: If the directory already exists this method will succeed if withIntermediateDirectories is true.
            ///
            try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)

            guard fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
                else {
                    XCTFail("Failed to create log file: \(url.absoluteString)")
                    return nil
            }
        }

        outputStream = try FileOutputStream(url: url)
    } catch {
        XCTFail("Failed to create output handle for test: \(error).")
        return nil
    }

    let writer = ConsoleWriter(outputStream: outputStream, format: TextFormat())

    if configureTraceLog {
        TraceLog.configure(writers: [.direct(writer)], environment: ["LOG_ALL": "TRACE4"])
    }
    return TestHarness(writer: writer, reader: ConsoleWriterReader(fileName: fileName, directory: directory))
}

private class ConsoleWriterReader: Reader {

    private let fileName: String
    private let directory: String

    init(fileName: String, directory: String) {
        self.fileName  = fileName
        self.directory = directory
    }

    func logEntry(for writer: ConsoleWriter, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> TestLogEntry? {

        do {
            ///
            /// Parse the log entry string.
            ///
            /// Note: ConsoleWriterReader is specific to ConsoleWriter and looks for a newline at the end of a line or it won't match the log entry (this is intentional).
            ///
            guard let regex = try? NSRegularExpression(pattern: "(\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3}) (.*)\\[(.*?):(.*?)\\]\\s+(ERROR|WARNING|INFO|TRACE1|TRACE2|TRACE3|TRACE4): <(.*?)> (.*[\\r?\\n|\\r])")
                else { return nil }

            let url = URL(fileURLWithPath: self.directory).appendingPathComponent(fileName)

            let entry = try String(contentsOf: url)

            ///
            /// Should be one log entry per file.
            ///
            guard let matches = regex.firstMatch(in: entry, options: [.withTransparentBounds], range: NSRange(entry.startIndex..., in: entry))
                else { return nil }

            /// Timestamp
            let timestamp = { () -> Double? in

                guard let dateRange = Range(matches.range(at: 1), in: entry)
                    else { return nil }
                guard let timestamp = TextFormat.Default.dateFormatter.date(from: String(entry[dateRange]))?.timeIntervalSince1970
                    else { return nil }

                return timestamp
            }()

            /// Process Name
            let processName = { () -> String? in
                guard let range = Range(matches.range(at: 2), in: entry)
                    else { return nil }
                return String(entry[range])
            }()

            /// Process Identifier
            let processIdentifier = { () -> Int? in
                guard let range = Range(matches.range(at: 3), in: entry)
                    else { return nil }
                return Int(entry[range])
            }()

            /// Thread Identifier
            let threadIdentifier = { () -> Int? in
                guard let range = Range(matches.range(at: 4), in: entry)
                    else { return nil }
                return Int(entry[range])
            }()

            /// Log Level
            let level = { () -> LogLevel? in
                guard let range = Range(matches.range(at: 5), in: entry)
                    else { return nil }
                switch String(entry[range]) {
                case "ERROR":   return LogLevel.error
                case "WARNING": return LogLevel.warning
                case "INFO":    return LogLevel.info
                case "TRACE1":  return LogLevel.trace1
                case "TRACE2":  return LogLevel.trace2
                case "TRACE3":  return LogLevel.trace3
                case "TRACE4":  return LogLevel.trace4
                default:
                    return nil
                }
            }()

            let tag = { () -> String? in
                guard let range = Range(matches.range(at: 6), in: entry)
                    else { return nil }
                return String(entry[range])
            }()

            let message = { () -> String? in
                guard let range = Range(matches.range(at: 7), in: entry)
                    else { return nil }
                ///
                /// Note: Now that we are sure we found the newline, we strip
                /// it away because that is an internal character added to the
                /// users message.  The compare routine expects to see in the
                /// result the message the user passed not the control chars,
                /// therefore, the newline is only used for matching purposes.
                ///
                return String(entry[range]).replacingOccurrences(of: "\n", with: "")
            }()

            return TestLogEntry(timestamp: timestamp,
                            level: level,
                            message: message,
                            tag: tag,
                            processName: processName,
                            processIdentifier: processIdentifier,
                            threadIdentifier: threadIdentifier)

        } catch { /* Fallthrough */ }

        return nil
    }
}
