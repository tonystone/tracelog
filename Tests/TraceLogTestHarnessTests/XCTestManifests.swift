import XCTest

extension AnyReaderTests {
    static let __allTests = [
        ("test_AnyReaderBase", test_AnyReaderBase),
        ("test_AnyReaderBox", test_AnyReaderBox),
    ]
}

extension TestHarnessTests {
    static let __allTests = [
        ("testLogForError", testLogForError),
        ("testLogForInfo", testLogForInfo),
        ("testLogForTrace1", testLogForTrace1),
        ("testLogForTrace2", testLogForTrace2),
        ("testLogForTrace3", testLogForTrace3),
        ("testLogForTrace4", testLogForTrace4),
        ("testLogForWarning", testLogForWarning),
        ("testLogTestBlockForError", testLogTestBlockForError),
        ("testLogTestBlockForInfo", testLogTestBlockForInfo),
        ("testLogTestBlockForTrace1", testLogTestBlockForTrace1),
        ("testLogTestBlockForTrace2", testLogTestBlockForTrace2),
        ("testLogTestBlockForTrace3", testLogTestBlockForTrace3),
        ("testLogTestBlockForTrace4", testLogTestBlockForTrace4),
        ("testLogTestBlockForWarning", testLogTestBlockForWarning),
        ("testLogTestBlockWithCustomFile", testLogTestBlockWithCustomFile),
        ("testLogTestBlockWithCustomFunction", testLogTestBlockWithCustomFunction),
        ("testLogTestBlockWithCustomLine", testLogTestBlockWithCustomLine),
        ("testLogTestBlockWithCustomMessage", testLogTestBlockWithCustomMessage),
        ("testLogTestBlockWithCustomTag", testLogTestBlockWithCustomTag),
        ("testLogWithCustomFile", testLogWithCustomFile),
        ("testLogWithCustomFunction", testLogWithCustomFunction),
        ("testLogWithCustomLine", testLogWithCustomLine),
        ("testLogWithCustomMessage", testLogWithCustomMessage),
        ("testLogWithCustomTag", testLogWithCustomTag),
    ]
}

#if !os(macOS)
extension TestUtilitiesTests {
    static let __allTests = [
        ("testShell", testShell),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnyReaderTests.__allTests),
        testCase(TestHarnessTests.__allTests),
        testCase(TestUtilitiesTests.__allTests),
    ]
}
#endif
