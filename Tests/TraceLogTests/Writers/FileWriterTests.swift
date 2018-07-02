///
///  FileWriterTests.swift
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
///  Created by Tony Stone on 6/27/18.
///

import XCTest
import TraceLogTestHarness

@testable import TraceLog

let testDirectory = "TraceLogTestsTmp"

let testEqual: (FileWriter, LogEntry?, LogEntry) -> Void = { writer, result, expected in

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
class FileWriterTests: XCTestCase {

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

    // MARK: - Init method tests

    ///
    /// A new log file should be created for each init.
    ///
    func testRotationOnInit() throws {

        let type    = String(describing: FileWriterTests.self)
        let function = (#function).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

        let fileName  = "\(type).\(function)"
        let fileExt   = ".log"
        let filePattern = "\(fileName)-(\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3})\(fileExt)"

        guard let regex = try? NSRegularExpression(pattern: filePattern)
            else { XCTFail("Failed to create regex for testing logfile existence."); return  }

        let fileManager = FileManager.default

        _  = try FileWriter(fileConfiguration: FileWriter.Configuration(fileName: fileName + fileExt, directory: testDirectory))

        /// Test for fileName + fileExt

        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/\(fileName)\(fileExt)"))

        _  = try FileWriter(fileConfiguration: FileWriter.Configuration(fileName: fileName + fileExt, directory: testDirectory))

        /// Test for fileName + fileExt and fileName + "-" + date + fileExt

        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/\(fileName)\(fileExt)"))

        for file in try fileManager.contentsOfDirectory(atPath: testDirectory) {
            if regex.firstMatch(in: file, range: NSRange(file.startIndex..., in: file)) != nil {
                return /// We found it so the test is complete
            }
        }
        XCTFail("Could not locate archive file using pattern: \(filePattern)")
    }

    func testCanNotCreateLogFileOnInit() {

        let type    = String(describing: FileWriterTests.self)
        let function = (#function).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

        let fileName  = "\(type).\(function).log"
        let directory = "DirectoryThatDoesNotExist"

        ///
        /// Since the file cannot be created in the a directory that does not exist.
        ///
        XCTAssertThrowsError(try FileWriter(fileConfiguration: FileWriter.Configuration(fileName: fileName, directory: directory))) { (error) in
            switch error {
            case FileWriter.Error.createFailed(let message):
                XCTAssertNotNil(message.range(of: "^Failed to create log file: .*/FileWriterTests.testCanNotCreateLogFileOnInit.log$", options: [.regularExpression, .anchored]))

            default: XCTFail("Incorrect error returned: \(error)")
            }
        }
    }

    // MARK: - Direct calls to the writer with default conversion table.

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

extension FileWriterTests {
    static var allTests: [(String, (FileWriterTests) -> () throws -> Void)] {
        return [
            ("testRotationOnInit", testRotationOnInit),
            ("testCanNotCreateLogFileOnInit", testCanNotCreateLogFileOnInit),
            ("testLogError", testLogError),
            ("testLogWarning", testLogWarning),
            ("testLogInfo", testLogInfo),
            ("testLogTrace1", testLogTrace1),
            ("testLogTrace2", testLogTrace2),
            ("testLogTrace3", testLogTrace3),
            ("testLogTrace4", testLogTrace4)
        ]
    }
}

///
/// Logging through TraceLog to the Logger
///
class TraceLogWithFileWriterTests: XCTestCase {

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

    func testLogError() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .error, testBlock: { (tag, message, file, function, line) in

            logError(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogWarning() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .warning, testBlock: { (tag, message, file, function, line) in

            logWarning(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogInfo() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .info, testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace1() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .trace1, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 1, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace2() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .trace2, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 2, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace3() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .trace3, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 3, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace4() {

        testHarness(for: type(of: self), configureTraceLog: true)?.testLog(for: .trace4, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 4, file, function, line) { message }

        }, validationBlock: testEqual)
    }
}

extension TraceLogWithFileWriterTests {
    static var allTests: [(String, (TraceLogWithFileWriterTests) -> () throws -> Void)] {
        return [
            ("testLogError", testLogError),
            ("testLogWarning", testLogWarning),
            ("testLogInfo", testLogInfo),
            ("testLogTrace1", testLogTrace1),
            ("testLogTrace2", testLogTrace2),
            ("testLogTrace3", testLogTrace3),
            ("testLogTrace4", testLogTrace4),
        ]
    }
}

///
/// Creates a TestHarness for the specific test class and function.
///
func testHarness<T>(for callerType: T.Type, configureTraceLog: Bool = false, directory: String = testDirectory,function: String = #function) -> TestHarness<FileReader>? {

    let type    = String(describing: callerType)
    let function = function.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

    let fileName  = "\(type).\(function).log"

    let writer: FileWriter
    do {
        writer  = try FileWriter(fileConfiguration: FileWriter.Configuration(fileName: fileName, directory: directory))
    } catch {
        XCTFail("Failed to instantiate FileWriter: \(error)"); return nil
    }

    if configureTraceLog {
        TraceLog.configure(writers: [.direct(writer)], environment: ["LOG_ALL": "TRACE4"])
    }
    return TestHarness(writer: writer, reader: FileReader(fileName: fileName, directory: directory))
}

class FileReader: Reader {

    private let fileName: String
    private let directory: String

    init(fileName: String, directory: String) {
        self.fileName  = fileName
        self.directory = directory
    }

    func logEntry(for writer: FileWriter, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogEntry? {

        do {
            let url = URL(fileURLWithPath: self.directory).appendingPathComponent(fileName)

            let data = try String(contentsOf: url)
            let entries = data.components(separatedBy: .newlines)

            for entry in entries {
                if entry.contains(message) {

                    ///
                    /// Parse the log entry string.
                    ///
                    guard let regex = try? NSRegularExpression(pattern: "(\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3}) (.*)\\[(.*?):(.*?)\\]\\s+(ERROR|WARNING|INFO|TRACE1|TRACE2|TRACE3|TRACE4): <(.*?)> (.*)")
                        else { return nil }

                    guard let matches = regex.firstMatch(in: entry, range: NSRange(entry.startIndex..., in: entry))
                        else { return nil }

                    /// Timestamp
                    let timestamp = { () -> Double? in

                        guard let dateRange = Range(matches.range(at: 1), in: entry)
                            else { return nil }
                        guard let timestamp = FileWriter.Default.dateFormatter.date(from: String(entry[dateRange]))?.timeIntervalSince1970
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
                        return String(entry[range]).replacingOccurrences(of: "\n", with: "")
                    }()

                    return LogEntry(timestamp: timestamp,
                                    level: level,
                                    message: message,
                                    tag: tag,
                                    processName: processName,
                                    processIdentifier: processIdentifier,
                                    threadIdentifier: threadIdentifier)
                }
            }

        } catch {}

        return nil
    }
}
