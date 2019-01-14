///
///  TextFormat+EncodingTests.swift
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
///  Created by Tony Stone on 12/31/18.
///
import XCTest

import TraceLog

/// TextFormat Encoding Tests.
///
class TextFormatEncodingWithUnicodeTests: XCTestCase {

    /// Test that we can encode a simple Ascii message to `String.Encoding.ascii`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testAsciiEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .ascii, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".ascii\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .ascii), expected, "Failed conversion to \".ascii\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.iso2022JP`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testIso2022JpEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .iso2022JP, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".iso2022JP\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .iso2022JP), expected, "Failed conversion to \".iso2022JP\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.isoLatin1`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testIsolatin1EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .isoLatin1, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".isoLatin1\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .isoLatin1), expected, "Failed conversion to \".isoLatin1\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.isoLatin2`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testIsolatin2EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .isoLatin2, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".isoLatin2\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .isoLatin2), expected, "Failed conversion to \".isoLatin2\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.macOSRoman`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testMacosromanEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .macOSRoman, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".macOSRoman\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .macOSRoman), expected, "Failed conversion to \".macOSRoman\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.nextstep`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testNextstepEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .nextstep, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".nextstep\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .nextstep), expected, "Failed conversion to \".nextstep\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.nonLossyASCII`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testNonlossyasciiEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .nonLossyASCII, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".nonLossyASCII\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .nonLossyASCII), expected, "Failed conversion to \".nonLossyASCII\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.shiftJIS`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testShiftjisEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .shiftJIS, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".shiftJIS\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .shiftJIS), expected, "Failed conversion to \".shiftJIS\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.unicode`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUnicodeEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .unicode, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".unicode\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .unicode), expected, "Failed conversion to \".unicode\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf16`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf16EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf16, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf16\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf16), expected, "Failed conversion to \".utf16\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf16BigEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf16BigendianEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf16BigEndian, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf16BigEndian\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf16BigEndian), expected, "Failed conversion to \".utf16BigEndian\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf16LittleEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf16LittleendianEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf16LittleEndian, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf16LittleEndian\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf16LittleEndian), expected, "Failed conversion to \".utf16LittleEndian\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf32`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf32EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf32, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf32\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf32), expected, "Failed conversion to \".utf32\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf32BigEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf32BigendianEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf32BigEndian, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf32BigEndian\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf32BigEndian), expected, "Failed conversion to \".utf32BigEndian\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf32LittleEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf32LittleendianEncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf32LittleEndian, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf32LittleEndian\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf32LittleEndian), expected, "Failed conversion to \".utf32LittleEndian\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.utf8`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testUtf8EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".utf8\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion to \".utf8\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.windowsCP1250`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testWindowscp1250EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1250, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1250\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .windowsCP1250), expected, "Failed conversion to \".windowsCP1250\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.windowsCP1251`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testWindowscp1251EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1251, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1251\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .windowsCP1251), expected, "Failed conversion to \".windowsCP1251\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.windowsCP1252`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testWindowscp1252EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1252, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1252\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .windowsCP1252), expected, "Failed conversion to \".windowsCP1252\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.windowsCP1253`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testWindowscp1253EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1253, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1253\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .windowsCP1253), expected, "Failed conversion to \".windowsCP1253\".")
    }

    /// Test that we can encode a simple Ascii message to `String.Encoding.windowsCP1254`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using just Ascii characters in the messages.
    ///
    func testWindowscp1254EncodingWithSimpleAsciiMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Simple Ascii text.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Simple Ascii text."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1254, terminator: "")

        guard let bytes = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1254\""); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .windowsCP1254), expected, "Failed conversion to \".windowsCP1254\".")
    }


    /// Test that we can encode a Unicode message to `String.Encoding.ascii`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testAsciiEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .ascii, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .ascii)
            else { XCTFail("Failed to convert log entry to encoding \".ascii\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".ascii\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.iso2022JP`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testIso2022JpEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .iso2022JP, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .iso2022JP)
            else { XCTFail("Failed to convert log entry to encoding \".iso2022JP\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".iso2022JP\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.isoLatin1`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testIsolatin1EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .isoLatin1, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .isoLatin1)
            else { XCTFail("Failed to convert log entry to encoding \".isoLatin1\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".isoLatin1\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.isoLatin2`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testIsolatin2EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .isoLatin2, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .isoLatin2)
            else { XCTFail("Failed to convert log entry to encoding \".isoLatin2\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".isoLatin2\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.macOSRoman`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testMacosromanEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .macOSRoman, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .macOSRoman)
            else { XCTFail("Failed to convert log entry to encoding \".macOSRoman\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".macOSRoman\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.nextstep`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testNextstepEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .nextstep, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .nextstep)
            else { XCTFail("Failed to convert log entry to encoding \".nextstep\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".nextstep\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.nonLossyASCII`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testNonlossyasciiEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .nonLossyASCII, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .nonLossyASCII)
            else { XCTFail("Failed to convert log entry to encoding \".nonLossyASCII\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".nonLossyASCII\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.shiftJIS`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testShiftjisEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .shiftJIS, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .shiftJIS)
            else { XCTFail("Failed to convert log entry to encoding \".shiftJIS\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".shiftJIS\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.unicode`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUnicodeEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .unicode, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .unicode)
            else { XCTFail("Failed to convert log entry to encoding \".unicode\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".unicode\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf16`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf16EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf16, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf16)
            else { XCTFail("Failed to convert log entry to encoding \".utf16\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf16\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf16BigEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf16BigendianEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf16BigEndian, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf16BigEndian)
            else { XCTFail("Failed to convert log entry to encoding \".utf16BigEndian\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf16BigEndian\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf16LittleEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf16LittleendianEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf16LittleEndian, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf16LittleEndian)
            else { XCTFail("Failed to convert log entry to encoding \".utf16LittleEndian\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf16LittleEndian\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf32`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf32EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf32, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf32)
            else { XCTFail("Failed to convert log entry to encoding \".utf32\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf32\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf32BigEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf32BigendianEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf32BigEndian, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf32BigEndian)
            else { XCTFail("Failed to convert log entry to encoding \".utf32BigEndian\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf32BigEndian\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf32LittleEndian`.
    ///
    /// Note: This will be a "NON-LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf32LittleendianEncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf32LittleEndian, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf32LittleEndian)
            else { XCTFail("Failed to convert log entry to encoding \".utf32LittleEndian\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf32LittleEndian\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.utf8`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testUtf8EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪."

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .utf8)
            else { XCTFail("Failed to convert log entry to encoding \".utf8\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".utf8\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.windowsCP1250`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testWindowscp1250EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1250, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .windowsCP1250)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1250\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".windowsCP1250\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.windowsCP1251`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testWindowscp1251EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1251, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .windowsCP1251)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1251\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".windowsCP1251\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.windowsCP1252`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testWindowscp1252EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1252, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .windowsCP1252)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1252\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".windowsCP1252\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.windowsCP1253`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testWindowscp1253EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1253, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .windowsCP1253)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1253\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".windowsCP1253\".")
    }

    /// Test that we can encode a Unicode message to `String.Encoding.windowsCP1254`.
    ///
    /// Note: This will be a "LOSSY" operation when using Unicode characters in the messages.
    ///
    func testWindowscp1254EncodingWithUnicodeMessage() {
        let entry: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Print a few unicode characters ♡, 🌍, 🇵🇷, 🐌, 🐧, 🐪.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Print a few unicode characters \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}, \\?{1,4}."

        let format = TextFormat(template: "%{message}", encoding: .windowsCP1254, terminator: "")

        guard let bytes = format.bytes(from: entry),
              let result = String(bytes: bytes, encoding: .windowsCP1254)
            else { XCTFail("Failed to convert log entry to encoding \".windowsCP1254\""); return }

        XCTAssertTrue(result.range(of: expected, options: [.regularExpression, .caseInsensitive]) != nil, "Failed conversion to \".windowsCP1254\".")
    }
}
