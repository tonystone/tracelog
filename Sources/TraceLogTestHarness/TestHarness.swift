///
///  TestHarness.swift
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
import Foundation
import TraceLog

///
/// A log reader that searches for a record matching some criteria in the logs and returns it as a `LogEntry` instance.
///
public protocol Reader {

    ///
    /// Defines the Writer class/struct that this Reader is designed to read the log entries for.
    ///
    associatedtype WriterType: Writer

    ///
    /// Locate the log entry based on the input and return it as a `LogEntry` instance.
    ///
    func logEntry(for writer: WriterType, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogEntry?
}

///
/// A test harness used for testing TraceLog itself and TraceLog pluggable `Writer` classes.
///
public class TestHarness<T: Reader> {

    ///
    /// The Writer under test.
    ///
    public let writer: T.WriterType

    ///
    /// Boxed version of the reader so it can be stored.
    ///
    private let reader: _AnyReaderBox<T>

    ///
    /// Initialize a test harness with the specified writer that is under test and a reader to search for the entry so it can be validated.
    ///
    public init(writer: T.WriterType, reader: T) {
        self.writer = writer
        self.reader = _AnyReaderBox(reader)
    }

    ///
    /// Executes test block (that must contain a call one of TraceLogs log functions) and validates the results.
    ///
    public func testLog(for level: LogLevel, tag tagOrNil: String? = nil, message messageOrNil: String? = nil, file: String = #file, function: String = #function, line: Int = #line,
                        testBlock: (String, String, String, String, Int) -> Void, validationBlock: (_ writer: T.WriterType, _ result: LogEntry?, _ expected: LogEntry)-> Void)  {

        self._testLog(for: level, tag: tagOrNil, message: messageOrNil, file: file, function: function, line: line, testBlock: { (timestamp, level, tag, message, runtimeContext, staticContext) in

            testBlock(tag, message, file, function, line)

        }, validationBlock: validationBlock)
    }

    ///
    /// Calls the writer directly with the given LogLevel and validates the results.
    ///
    public func testLog(for level: LogLevel, tag tagOrNil: String? = nil, message messageOrNil: String? = nil, file: String = #file, function: String = #function, line: Int = #line,
                        validationBlock: (_ writer: T.WriterType, _ result: LogEntry?, _ expected: LogEntry)-> Void)  {

        self._testLog(for: level, tag: tagOrNil, message: messageOrNil, file: file, function: function, line: line, testBlock: { (timestamp, level, tag, message, runtimeContext, staticContext) in

            /// Execute the test
            self.writer.log(timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)

        }, validationBlock: validationBlock)
    }

    ///
    /// Test a TraceLog log message to a writer.
    ///
    private func _testLog(for level: LogLevel, tag tagOrNil: String? = nil, message messageOrNil: String? = nil, file: String = #file, function: String = #function, line: Int = #line,
                        testBlock: (Double, LogLevel, String, String, RuntimeContext, StaticContext) -> Void, validationBlock: (_ writer: T.WriterType, _ result: LogEntry?, _ expected: LogEntry)-> Void)  {

        /// This is the time in microseconds since the epoch UTC to match the journals time stamps.
        let timestamp = Date().timeIntervalSince1970 * 1000.0

        let staticContext  = TestStaticContext(file, function, line)
        let runtimeContext = TestRuntimeContext()

        let tag     = tagOrNil     ?? "TestTag"
        let message = messageOrNil ?? "Writer test .\(level) message at timestamp \(timestamp)"

        /// Execute the test
        testBlock(timestamp, level, tag, message, runtimeContext, staticContext)

        let result = self.reader.logEntry(for: self.writer, timestamp: timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)

        let expected = LogEntry(timestamp: timestamp, level: level, message: message, tag: tag, file: staticContext.file, function: staticContext.function, line: staticContext.line, processName: runtimeContext.processName, processIdentifier: runtimeContext.processIdentifier, threadIdentifier: Int(runtimeContext.threadIdentifier))

        validationBlock(self.writer, result, expected)
    }
}

///
/// Structure representing a log entry (for both expected values and results of searches).
///
public struct LogEntry {

    public init(timestamp: Double, level: LogLevel, message: String, tag: String? = nil, file: String? = nil, function: String? = nil, line: Int? = nil, processName: String? = nil, processIdentifier: Int? = nil, threadIdentifier: Int? = nil, customAttributes: [String: Any]? = nil) {

        /// Required
        self.timestamp = timestamp
        self.level = level
        self.message = message

        /// Optional
        self.tag = tag
        self.file = file
        self.function = function
        self.line = line
        self.processName = processName
        self.processIdentifier = processIdentifier
        self.threadIdentifier = threadIdentifier
        self.customAttributes = customAttributes

    }
    public let timestamp: Double
    public let level: LogLevel
    public let message: String

    public let tag: String?
    public let file: String?
    public let function: String?
    public let line: Int?
    public let processName: String?
    public let processIdentifier: Int?
    public let threadIdentifier: Int?
    public let customAttributes: [String: Any]?
}


///
/// Private boxing class for use in storing our Reader which has an associated type.
///
private class _AnyReaderBox<ConcreteReader: Reader>: _AnyReaderBase<ConcreteReader.WriterType> {

    var reader: ConcreteReader

    init(_ reader: ConcreteReader) {
        self.reader = reader
    }

    override func logEntry(for writer: ConcreteReader.WriterType, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogEntry? {
        return self.reader.logEntry(for: writer, timestamp: timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)
    }
}

///
/// Private boxing class base for use in storing our Reader which has an associated type.
///
private class _AnyReaderBase<T: Writer>: Reader {

    func logEntry(for writer: T, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogEntry? {
        fatalError("Must override")
    }
}

///
/// StaticContext structure for tests which captures the context for each test func.
///
private struct TestStaticContext: StaticContext {
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
private struct TestRuntimeContext: RuntimeContext {

    public let processName: String
    public let processIdentifier: Int
    public let threadIdentifier: UInt64

    init(_ threadIdentifier: UInt64 = 0) {
        let process  = ProcessInfo.processInfo
        self.processName = process.processName
        self.processIdentifier = Int(process.processIdentifier)

        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            var threadID: UInt64 = 0

            pthread_threadid_np(pthread_self(), &threadID)
            self.threadIdentifier = threadID
        #else   // FIXME: Linux does not support the pthread_threadid_np function, gettid in s syscall must be used.
            self.threadIdentifier = 0
        #endif
    }
}
