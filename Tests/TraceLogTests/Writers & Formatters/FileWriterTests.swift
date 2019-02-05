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

@testable import TraceLog

private let testDirectory = "FileWriterTestsTmp"

private let testEqual: (FileWriter, TestLogEntry?, TestLogEntry) -> Void = { writer, result, expected in

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

    // MARK: - Error

    func testErrorCreateFailedDescription() {
        let input = FileWriter.Error.createFailed("Test createFailed message")
        let expected = "Test createFailed message"

        XCTAssertEqual(input.description, expected)
    }

    func testErrorFileDoesNotExistDescription() {
        let input = FileWriter.Error.fileDoesNotExist("Test fileDoesNotExist message")
        let expected = "Test fileDoesNotExist message"

        XCTAssertEqual(input.description, expected)
    }

    // MARK: - Init method tests

    ///
    /// A new log file should be created for each init.
    ///
    func testRotationOnInit() throws {

        let type    = String(describing: FileWriterTests.self)
        let function = (#function).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

        let fileName  = "\(type).\(function)"
        let fileExt   = "log"

        let fileManager = FileManager.default

        _  = try FileWriter(fileConfiguration: FileWriter.FileConfiguration(name: "\(fileName).\(fileExt)", directory: testDirectory))

        /// Test for fileName + fileExt

        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/\(fileName).\(fileExt)"))

        _  = try FileWriter(fileConfiguration: FileWriter.FileConfiguration(name: "\(fileName).\(fileExt)", directory: testDirectory))

        /// Test for fileName + fileExt and fileName + "-" + date + fileExt

        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/\(fileName).\(fileExt)"))
        XCTAssertTrue(try archiveExists(fileName: fileName, fileExt: fileExt, directory: testDirectory))
    }

        ///
    /// A new log file should be created for each init.
    ///
    func testRotationOnWrite() throws {

        let type    = String(describing: FileWriterTests.self)
        let function = (#function).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

        let fileName  = "\(type).\(function)"
        let fileExt   = "log"

        let testHarness = TestHarness(writer: try FileWriter(fileConfiguration: FileWriter.FileConfiguration(name: "\(fileName).\(fileExt)", directory: testDirectory, maxSize: 64)), reader: FileReader(fileName: fileName, directory: testDirectory))

        let fileManager = FileManager.default

        /// Test for fileName + fileExt but archive does not exist

        XCTAssertFalse(try archiveExists(fileName: fileName, fileExt: fileExt, directory: testDirectory), "Archive exists already.")
        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/\(fileName).\(fileExt)"))

        ///
        /// Writing to the log should force a log rotation since the maxSize is set below the size of the message.
        ///
        testHarness.testLog(for: .info, validationBlock: { _,_,_ in } )

        /// Test for fileName + fileExt and fileName + "-" + date + fileExt

        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/\(fileName).\(fileExt)"))
        XCTAssertTrue(try archiveExists(fileName: fileName, fileExt: fileExt, directory: testDirectory))
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

///
/// Creates a TestHarness for the specific test class and function.
///
private func testHarness<T>(for callerType: T.Type, configureTraceLog: Bool = false, directory: String = testDirectory, function: String = #function) -> TestHarness<FileReader>? {

    let type    = String(describing: callerType)
    let function = function.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

    let fileName  = "\(type).\(function).log"

    let writer: FileWriter
    do {
        writer  = try FileWriter(fileConfiguration: FileWriter.FileConfiguration(name: fileName, directory: directory))
    } catch {
        XCTFail("Failed to instantiate FileWriter: \(error)"); return nil
    }

    if configureTraceLog {
        TraceLog.configure(writers: [.direct(writer)], environment: ["LOG_ALL": "TRACE4"])
    }
    return TestHarness(writer: writer, reader: FileReader(fileName: fileName, directory: directory))
}

private class FileReader: Reader {

    private let fileName: String
    private let directory: String

    init(fileName: String, directory: String) {
        self.fileName  = fileName
        self.directory = directory
    }

    func logEntry(for writer: FileWriter, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> TestLogEntry? {

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
                        return String(entry[range]).replacingOccurrences(of: "\n", with: "")
                    }()

                    return TestLogEntry(timestamp: timestamp,
                                    level: level,
                                    message: message,
                                    tag: tag,
                                    processName: processName,
                                    processIdentifier: processIdentifier,
                                    threadIdentifier: threadIdentifier)
                }
            }
        } catch { /* Fallthrough */ }

        return nil
    }
}
