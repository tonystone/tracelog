///
///  TextFormatTests.swift
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
///  Created by Tony Stone on 12/27/18.
///
import XCTest

import TraceLog

/// TextFormatTests
///
class TextFormatTests: XCTestCase {

    /// Note: TextFormat uses local time for date formatting
    /// by default so we need to create an instance of
    /// a DateFormatter to format timestamps correctly
    /// for test.
    ///
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone.current

        return formatter
    }()

    // MARK: - Public Interface Compatibility Tests

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    /// Note: This test failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.
    ///
    func testInitWithNoParameters() {
        XCTAssertNotNil(TextFormat())
    }

    /// Simulate the user creating an instance passing their own
    /// DateFormatter expecting that formatter to be used.
    ///
    /// Note: This test failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.
    ///
    func testInitWithDateFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"

        XCTAssertNotNil(TextFormat(dateFormatter: formatter))
    }

    /// Simulate the user creating an instance passing an override to
    /// the default stripControlCharacters parameter.
    ///
    /// Note: This test failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.
    ///
    func testInitWithStripControlCharacters() {
        XCTAssertNotNil(TextFormat(options: [.controlCharacters(.strip)]))
    }

    /// Simulate the user creating an instance passing an override to
    /// the default stripControlCharacters parameter and their own
    /// dateFormatter.
    ///
    /// Note: This test failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.
    ///
    func testInitWithStripControlCharactersAndDateFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"

        XCTAssertNotNil(TextFormat(dateFormatter: formatter, options: [.controlCharacters(.strip)]))
    }

    /// Simulate the user creating an instance passing an override to
    /// the default terminator parameter.
    ///
    /// Note: This test failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.
    ///
    func testInitWithTerminator() {
        XCTAssertNotNil(TextFormat(terminator: ",\n"))
    }

    /// Simulate the user creating an instance passing an override to
    /// the default template parameter.
    ///
    /// Note: This test failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.
    ///
    func testInitWithTemplate() {
        XCTAssertNotNil(TextFormat(template: "%{timestamp}: %{message}"))
    }

    // MARK: - Template tests

    /// These tests test the individual variable substitutions
    /// available to the user.
    ///

    /// Substitution: %{date}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateDate() {
        let format = TextFormat(template: "%{date}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = TextFormatTests.dateFormatter.string(from: Date(timeIntervalSince1970: input.timestamp))

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleDate() {
        let format = TextFormat(template: "%{date}%{date}%{date}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = String(repeating: TextFormatTests.dateFormatter.string(from: Date(timeIntervalSince1970: input.timestamp)), count: 3)

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{timestamp}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateTimestamp() {
        let format = TextFormat(template: "%{timestamp}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "28800.0"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleTimestamp() {
        let format = TextFormat(template: "%{timestamp}%{timestamp}%{timestamp}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "28800.028800.028800.0"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{level}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateLevel() {
        let format = TextFormat(template: "%{level}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "INFO"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleLevel() {
        let format = TextFormat(template: "%{level}%{level}%{level}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "INFOINFOINFO"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{tag}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateTag() {
        let format = TextFormat(template: "%{tag}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "TestTag"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleTag() {
        let format = TextFormat(template: "%{tag}%{tag}%{tag}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "TestTagTestTagTestTag"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{message}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateMessage() {
        let format = TextFormat(template: "%{message}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "Test message."

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleMessage() {
        let format = TextFormat(template: "%{message}%{message}%{message}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "Test message.Test message.Test message."

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{processName}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateProcessName() {
        let format = TextFormat(template: "%{processName}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "Test Process"), staticContext: TestStaticContext())
        let expected: String       = "Test Process"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleProcessName() {
        let format = TextFormat(template: "%{processName}%{processName}%{processName}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "Test Process"), staticContext: TestStaticContext())
        let expected: String       = "Test ProcessTest ProcessTest Process"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{processIdentifier}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateProcessIdentifier() {
        let format = TextFormat(template: "%{processIdentifier}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processIdentifier: 500), staticContext: TestStaticContext())
        let expected: String       = "500"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleProcessIdentifier() {
        let format = TextFormat(template: "%{processIdentifier}%{processIdentifier}%{processIdentifier}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processIdentifier: 500), staticContext: TestStaticContext())
        let expected: String       = "500500500"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{threadIdentifier}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateThreadIdentifier() {
        let format = TextFormat(template: "%{threadIdentifier}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(threadIdentifier: 200), staticContext: TestStaticContext())
        let expected: String       = "200"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleThreadIdentifier() {
        let format = TextFormat(template: "%{threadIdentifier}%{threadIdentifier}%{threadIdentifier}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(threadIdentifier: 200), staticContext: TestStaticContext())
        let expected: String       = "200200200"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{file}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateFile() {
        let format = TextFormat(template: "%{file}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(file: "TextFormatTests.swift"))
        let expected: String       = "TextFormatTests.swift"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleFile() {
        let format = TextFormat(template: "%{file}%{file}%{file}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(file: "TextFormatTests.swift"))
        let expected: String       = "TextFormatTests.swiftTextFormatTests.swiftTextFormatTests.swift"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{function}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateFunction() {
        let format = TextFormat(template: "%{function}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(function: "testTemplateFunction()"))
        let expected: String       = "testTemplateFunction()"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleFunction() {
        let format = TextFormat(template: "%{function}%{function}%{function}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(function: "testTemplateFunction()"))
        let expected: String       = "testTemplateFunction()testTemplateFunction()testTemplateFunction()"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Substitution: %{line}
    ///
    /// Test that you can specify the individual substitution parameter.
    ///
    func testTemplateLine() {
        let format = TextFormat(template: "%{line}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "120"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that you can specify the substitution parameter multiple times.
    ///
    func testTemplateMultipleLine() {
        let format = TextFormat(template: "%{line}%{line}%{line}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "120120120"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that the default template produces the correct message output.
    ///
    func testTemplateDefault() {
        let format = TextFormat(terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let expected: String       = "\(TextFormatTests.dateFormatter.string(from: Date(timeIntervalSince1970: input.timestamp))) TestProcess[100:1100] INFO: <TestTag> Test message."

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that a template containing all the variables
    /// is able to be output.
    ///
    func testTemplateWithAllVariables() {
        let format = TextFormat(template: "%{date} %{timestamp} %{processName}[%{processIdentifier}:%{threadIdentifier}] %{level}: <%{tag}> [%{file}:%{function}:%{line}] %{message}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .warning, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 50, threadIdentifier: 200), staticContext: TestStaticContext(file: "TextFormatTests.swift", function: "testTemplateWithAllVariables()", line: 306))
        let expected: String       = "\(TextFormatTests.dateFormatter.string(from: Date(timeIntervalSince1970: input.timestamp))) \(input.timestamp) TestProcess[50:200] WARNING: <TestTag> [TextFormatTests.swift:testTemplateWithAllVariables():306] Test message."

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that a template containing a tab delimited form.
    ///
    func testTemplateWithTabDelimited() {
        let format = TextFormat(template: "\"%{date}\", \"%{processName}\", %{processIdentifier}, %{threadIdentifier}, \"%{level}\", \"%{tag}\", \"%{message}\"", terminator: "\n")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .warning, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 50, threadIdentifier: 200), staticContext: TestStaticContext(file: "TextFormatTests.swift", function: "testTemplateWithAllVariables()", line: 306))
        let expected: String       = "\"\(TextFormatTests.dateFormatter.string(from: Date(timeIntervalSince1970: input.timestamp)))\", \"TestProcess\", 50, 200, \"WARNING\", \"TestTag\", \"Test message.\"\n"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that all template constants are passed through
    /// without change.
    ///
    func testTemplateConstantsArePassedThrough() {
        let format = TextFormat(template: "~!@#$%^&*()%{level}1234567890%{tag}abcdefghijklmnop", terminator: "")

        let input: Writer.LogEntry = (timestamp: 1.0, level: .warning, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 50, threadIdentifier: 200), staticContext: TestStaticContext(file: "TextFormatTests.swift", function: "testTemplateWithAllVariables()", line: 306))
        let expected: String       = "~!@#$%^&*()WARNING1234567890TestTagabcdefghijklmnop"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }


    /// MARK: - Negative tests on template form.

    /// Test that a random constant value will be printed as a constant.
    ///
    func testTemplateAllConstants() {
        let format = TextFormat(template: "{}} This is a constant string that will be output %{(0001234 with special characters}.", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "{}} This is a constant string that will be output %{(0001234 with special characters}."

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that any combination of %{} that is not a valid substitution variable
    /// prints as a constant.
    ///
    func testTemplateIncorrectVariables() {
        let format = TextFormat(template: "%{This} %{is} %{a} %{constant} %{string} %{that} %{will} %{be} %{output}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "%{This} %{is} %{a} %{constant} %{string} %{that} %{will} %{be} %{output}"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that a double %{} wrapped valid variable prints correctly.
    ///
    func testTemplateDoubleWrappedVariable() {
        let format = TextFormat(template: "%{%{level}}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "%{INFO}"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test a message with embedded variables does not substitute the embedded variables.
    ///
    func testTemplateMessageWithEmbeddedVaraibles() {
        let format = TextFormat(template: "%{level} %{message}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "%{level}", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "INFO %{level}"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test a message with embedded variables does not substitute the embedded variables.
    ///
    func testTemplateMessageWithEmbeddedVaraiblesReversed() {
        let format = TextFormat(template: "%{message} %{level}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "%{level}", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "%{level} INFO"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test a message with embedded message variables does not substitute the embedded variables.
    ///
    func testTemplateMessageWithEmbeddedMessageVariable() {
        let format = TextFormat(template: "%{message}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "%{message} check", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "%{message} check"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    // MARK: - Test .controlCharacters

    /// Test that by passing options: [.controlCharacters(.strip)],
    /// all control characters are stripped from the message
    /// portion of the output.
    ///
    func testControlCharactersStripActuallyStrips() {
        let format = TextFormat(template: "%{message}", options: [.controlCharacters(.strip)], terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "\tThis message contains multiple \nlines and \tcontrol characters.\n", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "This message contains multiple lines and control characters."

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that by passing options: [.controlCharacters(.escape)],
    /// all control characters are escaped int the message
    /// portion of the output.
    ///
    func testControlCharactersEscapeActuallyEscapes() {
        let format = TextFormat(template: "%{message}", options: [.controlCharacters(.escape)], terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "\tThis message contains multiple \nlines and \tcontrol characters.\n", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "\\tThis message contains multiple \\nlines and \\tcontrol characters.\\n"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    /// Test that by not passing options: [.controlCharacters(.strip)],
    /// all control characters are LEFT in the message
    /// portion of the output.
    ///
    func testControlCharactersAbsentLeavesTheCharacters() {
        let format = TextFormat(template: "%{message}", terminator: "")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "\tThis message contains multiple \nlines and \tcontrol characters.\n", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "\tThis message contains multiple \nlines and \tcontrol characters.\n"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }

    // MARK: - Test terminator

    /// Test that by passing a terminator string that it
    /// gets written to the output.
    ///
    func testTerminatorCanBeSet() {
        let format = TextFormat(template: "%{message}", options: [.controlCharacters(.strip)], terminator: ",\n\t")

        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let expected: String       = "Simple message.,\n\t"

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail(); return  }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected)
    }
}
