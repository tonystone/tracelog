///
///  TestHarnessTests.swift
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
///  Created by Tony Stone on 6/25/18.
///
import XCTest
import TraceLog

@testable import TraceLogTestHarness

private let testEqual: (BufferWriter, LogEntry?, LogEntry) -> Void = { writer, result, expected in

    guard let result = result
        else { XCTFail("Failed to locate log entry."); return }

    XCTAssertEqual(result.level,             expected.level)
    XCTAssertEqual(result.message,           expected.message)
    XCTAssertEqual(result.tag,               expected.tag)
    XCTAssertEqual(result.file,              expected.file)
    XCTAssertEqual(result.function,          expected.function)
    XCTAssertEqual(result.line,              expected.line)
    XCTAssertEqual(result.processName,       expected.processName)
    XCTAssertEqual(result.processIdentifier, expected.processIdentifier)
    XCTAssertEqual(result.threadIdentifier,  expected.threadIdentifier)
}

final class TestHarnessTests: XCTestCase {

    let testHarness = TestHarness(writer: BufferWriter(), reader: BufferReader())

    ///
    /// Testing the writer Implementation directly.
    ///

    // MARK: - Test Log with LegLevel

    func testLogForError() {

        testHarness.testLog(for: .error, validationBlock: testEqual)
    }

    func testLogForWarning() {

        testHarness.testLog(for: .warning, validationBlock: testEqual)
    }

    func testLogForInfo() {

        testHarness.testLog(for: .info, validationBlock: testEqual)
    }

    func testLogForTrace1() {

        testHarness.testLog(for: .trace1, validationBlock: testEqual)
    }

    func testLogForTrace2() {

        testHarness.testLog(for: .trace2, validationBlock: testEqual)
    }

    func testLogForTrace3() {

        testHarness.testLog(for: .trace3, validationBlock: testEqual)
    }

    func testLogForTrace4() {

        testHarness.testLog(for: .trace4, validationBlock: testEqual)
    }

    // MARK: - Test Log with Various overrides

    func testLogWithCustomMessage() {

        testHarness.testLog(for: .info, message: "Random test message.", validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.message, "Random test message.")
        })
    }

    func testLogWithCustomTag() {

        testHarness.testLog(for: .info, tag: "CustomTag", validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.tag, "CustomTag")
        })
    }

    func testLogWithCustomFile() {

        testHarness.testLog(for: .info, file: "/test/custom/file.swift", validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.file, "/test/custom/file.swift")
        })
    }

    func testLogWithCustomFunction() {

        testHarness.testLog(for: .info, function: "customTestFunction()", validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.function, "customTestFunction()")
        })
    }

    func testLogWithCustomLine() {

        testHarness.testLog(for: .info, line: 536, validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.line, 536)
        })
    }

    ///
    /// Testing the writer through TraceLog using a test block.
    ///

    // MARK: - Test Log with LegLevel

    func testLogTestBlockForError() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .error, testBlock: { (tag, message, file, function, line) in

            logError(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTestBlockForWarning() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .warning, testBlock: { (tag, message, file, function, line) in

            logWarning(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTestBlockForInfo() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .info, testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTestBlockForTrace1() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .trace1, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 1, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTestBlockForTrace2() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .trace2, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 2, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTestBlockForTrace3() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .trace3, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 3, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTestBlockForTrace4() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .trace4, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 4, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    // MARK: - Test Log with Various overrides

    func testLogTestBlockWithCustomMessage() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .info, message: "Random test message.", testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.message, "Random test message.")
        })
    }

    func testLogTestBlockWithCustomTag() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .info, tag: "CustomTag", testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.tag, "CustomTag")
        })
    }

    func testLogTestBlockWithCustomFile() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .info, file: "/test/custom/file.swift", testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.file, "/test/custom/file.swift")
        })
    }

    func testLogTestBlockWithCustomFunction() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .info, function: "customTestFunction()", testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.function, "customTestFunction()")
        })
    }

    func testLogTestBlockWithCustomLine() {

        TraceLog.configure(writers: [.direct(testHarness.writer)], environment: ["LOG_ALL": "TRACE4"])

        testHarness.testLog(for: .info, line: 536, testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: { writer, result, expected in

                XCTAssertEqual(result?.line, 536)
        })
    }
}

///
/// Misc Tests of AnyReader for completeness of coverage
///
class AnyReaderTests: XCTestCase {

    struct TestRunTimeContext: RuntimeContext {
        var processName: String      { return "TestProcess" }
        var processIdentifier: Int   { return 100 }
        var threadIdentifier: UInt64 { return 1100 }
    }

    struct TestStaticContext: StaticContext {
        var file: String     { return #file }
        var function: String { return #function }
        var line: Int        { return #line }
    }

    // MARK: - Test AnyReader

    func test_AnyReaderBase() {
        let anyReader = _AnyReaderBase<BufferWriter>()

        XCTAssertNil(anyReader.logEntry(for: BufferWriter(), timestamp: Date().timeIntervalSinceNow, level: .info, tag: "tag", message: "message", runtimeContext: TestRunTimeContext(), staticContext: TestStaticContext()))
    }

    func test_AnyReaderBox() {
        let anyReader = _AnyReaderBox(BufferReader())

        XCTAssertNil(anyReader.logEntry(for: BufferWriter(), timestamp: Date().timeIntervalSinceNow, level: .info, tag: "tag", message: "message", runtimeContext: TestRunTimeContext(), staticContext: TestStaticContext()))
    }
}
