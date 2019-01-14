///
///  JSONFormatTests.swift
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

/// JSONFormatTests
///
class JSONFormatTests: XCTestCase {

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
        XCTAssertNotNil(JSONFormat())
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
    func testInitWithPrettyPrint() {
        XCTAssertNotNil(JSONFormat(options: [.prettyPrint]))
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
        XCTAssertNotNil(JSONFormat(terminator: ",\n"))
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
    func testInitWithAttributes() {
        XCTAssertNotNil(JSONFormat(attributes: [.timestamp, .message]))
    }

    // MARK: - Template tests

    /// These tests test the individual attribute output
    /// available to the user.
    ///

    /// Attribute: .timestamp
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeTimestamp() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.timestamp], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"timestamp\":28800.0}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeTimestampPrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.timestamp], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"timestamp\" : 28800.0\n}")
    }

    /// Attribute: .level
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeLevel() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.level], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"level\":\"INFO\"}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeLevelPrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.level], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"level\" : \"INFO\"\n}")
    }

    /// Attribute: .tag
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeTag() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.tag], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"tag\":\"TestTag\"}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeTagPrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.tag], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"tag\" : \"TestTag\"\n}")
    }

    /// Attribute: .message
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.message], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"message\":\"Test message.\"}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeMessagePrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.message], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"message\" : \"Test message.\"\n}")
    }

    /// Attribute: .processName
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeProcessName() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess"), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.processName], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"processName\":\"TestProcess\"}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeProcessNamePrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess"), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.processName], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"processName\" : \"TestProcess\"\n}")
    }

    /// Attribute: .processIdentifier
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeProcessIdentifier() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processIdentifier: 120), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.processIdentifier], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"processIdentifier\":120}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeProcessIdentifierPrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processIdentifier: 120), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.processIdentifier], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"processIdentifier\" : 120\n}")
    }

    /// Attribute: .processIdentifier
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeThreadIdentifier() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processIdentifier: 120), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.processIdentifier], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"processIdentifier\":120}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeThreadIdentifierPrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processIdentifier: 120), staticContext: TestStaticContext())
        let format = JSONFormat(attributes: [.processIdentifier], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"processIdentifier\" : 120\n}")
    }

    /// Attribute: .file
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeFile() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(file: "JSONFormat.swift"))
        let format = JSONFormat(attributes: [.file], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"file\":\"JSONFormat.swift\"}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeFilePrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(file: "JSONFormat.swift"))
        let format = JSONFormat(attributes: [.file], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"file\" : \"JSONFormat.swift\"\n}")
    }

    /// Attribute: .function
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeFunction() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(function: "testAttributeFunction()"))
        let format = JSONFormat(attributes: [.function], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"function\":\"testAttributeFunction()\"}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeFunctionPrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(function: "testAttributeFunction()"))
        let format = JSONFormat(attributes: [.function], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"function\" : \"testAttributeFunction()\"\n}")
    }

    /// Attribute: .line
    ///
    /// Test that you can specify the individual attribute for output.
    ///
    func testAttributeLine() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 240))
        let format = JSONFormat(attributes: [.line], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"line\":240}")
    }

    /// Test that you can specify the individual attribute
    /// for output (printed with formatting characters).
    ///
    func testAttributeLinePrettyPrint() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 240))
        let format = JSONFormat(attributes: [.line], options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\n\t\"line\" : 240\n}")
    }

    func testAttributeDefaultList() throws {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 120, threadIdentifier: 200), staticContext: TestStaticContext(file: "JSONFormatTests.swift", function: "testAttributeDefaultList()", line: 240))
        let format = JSONFormat(terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        guard let json = try JSONSerialization.jsonObject(with: Data(bytes), options: []) as? [String: Any]
            else { return }

        XCTAssertEqual(json.count, 10)
        XCTAssertEqual(json["timestamp"] as? Double,       28800.0)
        XCTAssertEqual(json["level"] as? String,           "INFO")
        XCTAssertEqual(json["tag"] as? String,             "TestTag")
        XCTAssertEqual(json["message"] as? String,         "Test message.")
        XCTAssertEqual(json["processName"] as? String,     "TestProcess")
        XCTAssertEqual(json["processIdentifier"] as? Int,  120)
        XCTAssertEqual(json["threadIdentifier"] as? UInt64,200)
        XCTAssertEqual(json["file"] as? String,            "JSONFormatTests.swift")
        XCTAssertEqual(json["function"] as? String,        "testAttributeDefaultList()")
        XCTAssertEqual(json["line"] as? Int,               240)
    }

    func testAttributeDefaultListWithPrettyPrinting() throws {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Test message.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 120, threadIdentifier: 200), staticContext: TestStaticContext(file: "JSONFormatTests.swift", function: "testAttributeDefaultList()", line: 240))
        let format = JSONFormat( options: [.prettyPrint], terminator: "")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        guard let json = try JSONSerialization.jsonObject(with: Data(bytes), options: []) as? [String: Any]
            else { return }

        XCTAssertEqual(json.count, 10)
        XCTAssertEqual(json["timestamp"] as? Double,       28800.0)
        XCTAssertEqual(json["level"] as? String,           "INFO")
        XCTAssertEqual(json["tag"] as? String,             "TestTag")
        XCTAssertEqual(json["message"] as? String,         "Test message.")
        XCTAssertEqual(json["processName"] as? String,     "TestProcess")
        XCTAssertEqual(json["processIdentifier"] as? Int,  120)
        XCTAssertEqual(json["threadIdentifier"] as? UInt64,200)
        XCTAssertEqual(json["file"] as? String,            "JSONFormatTests.swift")
        XCTAssertEqual(json["function"] as? String,        "testAttributeDefaultList()")
        XCTAssertEqual(json["line"] as? Int,               240)
    }

    // MARK: - Test terminator

    /// Test that by passing a terminator string that it
    /// gets written to the output.
    ///
    func testTerminatorCanBeSet() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple message.", runtimeContext: TestRuntimeContext(), staticContext: TestStaticContext(line: 120))
        let format = JSONFormat(attributes: [.message], terminator: ",\n\t")

        guard let bytes =  format.bytes(from: input)
            else { XCTFail(); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), "{\"message\":\"Simple message.\"},\n\t")
    }
}
