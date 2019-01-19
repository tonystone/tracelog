#if !canImport(ObjectiveC)
import XCTest

extension ConfigurationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConfigurationTests = [
        ("testInit", testInit),
        ("testLoad_Prefixes", testLoad_Prefixes),
        ("testLoad_Tags", testLoad_Tags),
        ("testLogLevel_All_Default", testLogLevel_All_Default),
        ("testLogLevel_All_Set", testLogLevel_All_Set),
        ("testLogLevel_All_Set_Error", testLogLevel_All_Set_Error),
        ("testLogLevel_All_Set_Info", testLogLevel_All_Set_Info),
        ("testLogLevel_All_Set_InvalidLevel", testLogLevel_All_Set_InvalidLevel),
        ("testLogLevel_All_Set_Off", testLogLevel_All_Set_Off),
        ("testLogLevel_All_Set_Trace1", testLogLevel_All_Set_Trace1),
        ("testLogLevel_All_Set_Trace2", testLogLevel_All_Set_Trace2),
        ("testLogLevel_All_Set_Trace3", testLogLevel_All_Set_Trace3),
        ("testLogLevel_All_Set_Trace4", testLogLevel_All_Set_Trace4),
        ("testLogLevel_All_Set_Warning", testLogLevel_All_Set_Warning),
        ("testLogLevel_Prefix", testLogLevel_Prefix),
        ("testLogLevel_Tag", testLogLevel_Tag),
    ]
}

extension ConsoleWriterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConsoleWriterTests = [
        ("testLogError", testLogError),
        ("testLogInfo", testLogInfo),
        ("testLogTrace1", testLogTrace1),
        ("testLogTrace2", testLogTrace2),
        ("testLogTrace3", testLogTrace3),
        ("testLogTrace4", testLogTrace4),
        ("testLogWarning", testLogWarning),
    ]
}

extension EnvironmentTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__EnvironmentTests = [
        ("testInit", testInit),
        ("testInit_CollectionType", testInit_CollectionType),
        ("testInit_DictionaryLiteral", testInit_DictionaryLiteral),
        ("testSubscript", testSubscript),
    ]
}

extension FileOutputStreamErrorPosixTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileOutputStreamErrorPosixTests = [
        ("testErrorForEACCES", testErrorForEACCES),
        ("testErrorForEAGAIN", testErrorForEAGAIN),
        ("testErrorForEEXIST", testErrorForEEXIST),
        ("testErrorForEINTR", testErrorForEINTR),
        ("testErrorForEINVAL", testErrorForEINVAL),
        ("testErrorForEIO", testErrorForEIO),
        ("testErrorForEISDIR", testErrorForEISDIR),
        ("testErrorForELOOP", testErrorForELOOP),
        ("testErrorForEMFILE", testErrorForEMFILE),
        ("testErrorForENAMETOOLONG", testErrorForENAMETOOLONG),
        ("testErrorForENFILE", testErrorForENFILE),
        ("testErrorForENOENT", testErrorForENOENT),
        ("testErrorForENOMEM", testErrorForENOMEM),
        ("testErrorForENOSPC", testErrorForENOSPC),
        ("testErrorForENOSR", testErrorForENOSR),
        ("testErrorForENOTDIR", testErrorForENOTDIR),
        ("testErrorForENXIO", testErrorForENXIO),
        ("testErrorForEOVERFLOW", testErrorForEOVERFLOW),
        ("testErrorForEROFS", testErrorForEROFS),
        ("testErrorForETXTBSY", testErrorForETXTBSY),
        ("testErrorForOutOfRangeCode", testErrorForOutOfRangeCode),
    ]
}

extension FileOutputStreamTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileOutputStreamTests = [
        ("testInitWithFileDescriptor", testInitWithFileDescriptor),
        ("testInitWithURL", testInitWithURL),
        ("testInitWithURLFailsWithInvalidURL", testInitWithURLFailsWithInvalidURL),
        ("testPositionReturnsCorrectValueOnNormalFile", testPositionReturnsCorrectValueOnNormalFile),
        ("testPositionReturnsZeroWhenGivenAnInvalidFD", testPositionReturnsZeroWhenGivenAnInvalidFD),
        ("testtestPositionReturnsZeroWhenAppliedToStandardError", testtestPositionReturnsZeroWhenAppliedToStandardError),
        ("testtestPositionReturnsZeroWhenAppliedToStandardOut", testtestPositionReturnsZeroWhenAppliedToStandardOut),
        ("testWriteToFile", testWriteToFile),
        ("testWriteToFileWithFailedWriteOnClosedFile", testWriteToFileWithFailedWriteOnClosedFile),
    ]
}

extension FileWriterInternalsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileWriterInternalsTests = [
        ("testOpen", testOpen),
        ("testOpenCreatingDirectory", testOpenCreatingDirectory),
        ("testOpenFailure", testOpenFailure),
        ("testRotate", testRotate),
        ("testRotateFailure", testRotateFailure),
    ]
}

extension FileWriterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileWriterTests = [
        ("testErrorCreateFailedDescription", testErrorCreateFailedDescription),
        ("testErrorFileDoesNotExistDescription", testErrorFileDoesNotExistDescription),
        ("testLogError", testLogError),
        ("testLogInfo", testLogInfo),
        ("testLogTrace1", testLogTrace1),
        ("testLogTrace2", testLogTrace2),
        ("testLogTrace3", testLogTrace3),
        ("testLogTrace4", testLogTrace4),
        ("testLogWarning", testLogWarning),
        ("testRotationOnInit", testRotationOnInit),
        ("testRotationOnWrite", testRotationOnWrite),
    ]
}

extension JSONFormatTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__JSONFormatTests = [
        ("testAttributeDefaultList", testAttributeDefaultList),
        ("testAttributeDefaultListWithPrettyPrinting", testAttributeDefaultListWithPrettyPrinting),
        ("testAttributeFile", testAttributeFile),
        ("testAttributeFilePrettyPrint", testAttributeFilePrettyPrint),
        ("testAttributeFunction", testAttributeFunction),
        ("testAttributeFunctionPrettyPrint", testAttributeFunctionPrettyPrint),
        ("testAttributeLevel", testAttributeLevel),
        ("testAttributeLevelPrettyPrint", testAttributeLevelPrettyPrint),
        ("testAttributeLine", testAttributeLine),
        ("testAttributeLinePrettyPrint", testAttributeLinePrettyPrint),
        ("testAttributeMessage", testAttributeMessage),
        ("testAttributeMessagePrettyPrint", testAttributeMessagePrettyPrint),
        ("testAttributeProcessIdentifier", testAttributeProcessIdentifier),
        ("testAttributeProcessIdentifierPrettyPrint", testAttributeProcessIdentifierPrettyPrint),
        ("testAttributeProcessName", testAttributeProcessName),
        ("testAttributeProcessNamePrettyPrint", testAttributeProcessNamePrettyPrint),
        ("testAttributeTag", testAttributeTag),
        ("testAttributeTagPrettyPrint", testAttributeTagPrettyPrint),
        ("testAttributeThreadIdentifier", testAttributeThreadIdentifier),
        ("testAttributeThreadIdentifierPrettyPrint", testAttributeThreadIdentifierPrettyPrint),
        ("testAttributeTimestamp", testAttributeTimestamp),
        ("testAttributeTimestampPrettyPrint", testAttributeTimestampPrettyPrint),
        ("testInitWithAttributes", testInitWithAttributes),
        ("testInitWithNoParameters", testInitWithNoParameters),
        ("testInitWithPrettyPrint", testInitWithPrettyPrint),
        ("testInitWithTerminator", testInitWithTerminator),
        ("testTerminatorCanBeSet", testTerminatorCanBeSet),
    ]
}

extension MutexTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MutexTests = [
        ("testLockBlocked", testLockBlocked),
        ("testLockUnlock", testLockUnlock),
        ("testLockUnlockNonRecursiveBlocked", testLockUnlockNonRecursiveBlocked),
        ("testLockUnlockRecursive", testLockUnlockRecursive),
        ("testTryLockBlocked", testTryLockBlocked),
    ]
}

extension OutputStreamErrorPosixTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__OutputStreamErrorPosixTests = [
        ("testErrorForEACCES", testErrorForEACCES),
        ("testErrorForEAGAIN", testErrorForEAGAIN),
        ("testErrorForEBADF", testErrorForEBADF),
        ("testErrorForECONNRESET", testErrorForECONNRESET),
        ("testErrorForEFBIG", testErrorForEFBIG),
        ("testErrorForEINTR", testErrorForEINTR),
        ("testErrorForEINVAL", testErrorForEINVAL),
        ("testErrorForEIO", testErrorForEIO),
        ("testErrorForENETDOWN", testErrorForENETDOWN),
        ("testErrorForENETUNREACH", testErrorForENETUNREACH),
        ("testErrorForENOBUFS", testErrorForENOBUFS),
        ("testErrorForENOSPC", testErrorForENOSPC),
        ("testErrorForENXIO", testErrorForENXIO),
        ("testErrorForEPIPE", testErrorForEPIPE),
        ("testErrorForERANGE", testErrorForERANGE),
        ("testErrorForEWOULDBLOCK", testErrorForEWOULDBLOCK),
        ("testErrorForOutOfRangeCode", testErrorForOutOfRangeCode),
    ]
}

extension RuntimeContextTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__RuntimeContextTests = [
        ("testDescription", testDescription),
    ]
}

extension StandardStreamTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StandardStreamTests = [
        ("testErrorIsOutputStream", testErrorIsOutputStream),
        ("testErrorPosition", testErrorPosition),
        ("testOutIsOutputStream", testOutIsOutputStream),
        ("testOutPosition", testOutPosition),
    ]
}

extension StaticContextTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StaticContextTests = [
        ("testDescription", testDescription),
    ]
}

extension TextFormatEncodingWithUnicodeTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TextFormatEncodingWithUnicodeTests = [
        ("testAsciiEncodingWithSimpleAsciiMessage", testAsciiEncodingWithSimpleAsciiMessage),
        ("testAsciiEncodingWithUnicodeMessage", testAsciiEncodingWithUnicodeMessage),
        ("testIso2022JpEncodingWithSimpleAsciiMessage", testIso2022JpEncodingWithSimpleAsciiMessage),
        ("testIso2022JpEncodingWithUnicodeMessage", testIso2022JpEncodingWithUnicodeMessage),
        ("testIsolatin1EncodingWithSimpleAsciiMessage", testIsolatin1EncodingWithSimpleAsciiMessage),
        ("testIsolatin1EncodingWithUnicodeMessage", testIsolatin1EncodingWithUnicodeMessage),
        ("testIsolatin2EncodingWithSimpleAsciiMessage", testIsolatin2EncodingWithSimpleAsciiMessage),
        ("testIsolatin2EncodingWithUnicodeMessage", testIsolatin2EncodingWithUnicodeMessage),
        ("testMacosromanEncodingWithSimpleAsciiMessage", testMacosromanEncodingWithSimpleAsciiMessage),
        ("testMacosromanEncodingWithUnicodeMessage", testMacosromanEncodingWithUnicodeMessage),
        ("testNextstepEncodingWithSimpleAsciiMessage", testNextstepEncodingWithSimpleAsciiMessage),
        ("testNextstepEncodingWithUnicodeMessage", testNextstepEncodingWithUnicodeMessage),
        ("testNonlossyasciiEncodingWithSimpleAsciiMessage", testNonlossyasciiEncodingWithSimpleAsciiMessage),
        ("testNonlossyasciiEncodingWithUnicodeMessage", testNonlossyasciiEncodingWithUnicodeMessage),
        ("testShiftjisEncodingWithSimpleAsciiMessage", testShiftjisEncodingWithSimpleAsciiMessage),
        ("testShiftjisEncodingWithUnicodeMessage", testShiftjisEncodingWithUnicodeMessage),
        ("testUnicodeEncodingWithSimpleAsciiMessage", testUnicodeEncodingWithSimpleAsciiMessage),
        ("testUnicodeEncodingWithUnicodeMessage", testUnicodeEncodingWithUnicodeMessage),
        ("testUtf16BigendianEncodingWithSimpleAsciiMessage", testUtf16BigendianEncodingWithSimpleAsciiMessage),
        ("testUtf16BigendianEncodingWithUnicodeMessage", testUtf16BigendianEncodingWithUnicodeMessage),
        ("testUtf16EncodingWithSimpleAsciiMessage", testUtf16EncodingWithSimpleAsciiMessage),
        ("testUtf16EncodingWithUnicodeMessage", testUtf16EncodingWithUnicodeMessage),
        ("testUtf16LittleendianEncodingWithSimpleAsciiMessage", testUtf16LittleendianEncodingWithSimpleAsciiMessage),
        ("testUtf16LittleendianEncodingWithUnicodeMessage", testUtf16LittleendianEncodingWithUnicodeMessage),
        ("testUtf32BigendianEncodingWithSimpleAsciiMessage", testUtf32BigendianEncodingWithSimpleAsciiMessage),
        ("testUtf32BigendianEncodingWithUnicodeMessage", testUtf32BigendianEncodingWithUnicodeMessage),
        ("testUtf32EncodingWithSimpleAsciiMessage", testUtf32EncodingWithSimpleAsciiMessage),
        ("testUtf32EncodingWithUnicodeMessage", testUtf32EncodingWithUnicodeMessage),
        ("testUtf32LittleendianEncodingWithSimpleAsciiMessage", testUtf32LittleendianEncodingWithSimpleAsciiMessage),
        ("testUtf32LittleendianEncodingWithUnicodeMessage", testUtf32LittleendianEncodingWithUnicodeMessage),
        ("testUtf8EncodingWithSimpleAsciiMessage", testUtf8EncodingWithSimpleAsciiMessage),
        ("testUtf8EncodingWithUnicodeMessage", testUtf8EncodingWithUnicodeMessage),
        ("testWindowscp1250EncodingWithSimpleAsciiMessage", testWindowscp1250EncodingWithSimpleAsciiMessage),
        ("testWindowscp1250EncodingWithUnicodeMessage", testWindowscp1250EncodingWithUnicodeMessage),
        ("testWindowscp1251EncodingWithSimpleAsciiMessage", testWindowscp1251EncodingWithSimpleAsciiMessage),
        ("testWindowscp1251EncodingWithUnicodeMessage", testWindowscp1251EncodingWithUnicodeMessage),
        ("testWindowscp1252EncodingWithSimpleAsciiMessage", testWindowscp1252EncodingWithSimpleAsciiMessage),
        ("testWindowscp1252EncodingWithUnicodeMessage", testWindowscp1252EncodingWithUnicodeMessage),
        ("testWindowscp1253EncodingWithSimpleAsciiMessage", testWindowscp1253EncodingWithSimpleAsciiMessage),
        ("testWindowscp1253EncodingWithUnicodeMessage", testWindowscp1253EncodingWithUnicodeMessage),
        ("testWindowscp1254EncodingWithSimpleAsciiMessage", testWindowscp1254EncodingWithSimpleAsciiMessage),
        ("testWindowscp1254EncodingWithUnicodeMessage", testWindowscp1254EncodingWithUnicodeMessage),
    ]
}

extension TextFormatInternationalLanguagesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TextFormatInternationalLanguagesTests = [
        ("testBytesWithDanishMessage", testBytesWithDanishMessage),
        ("testBytesWithEnglishMessage", testBytesWithEnglishMessage),
        ("testBytesWithFrenchMessage", testBytesWithFrenchMessage),
        ("testBytesWithGermanMessage", testBytesWithGermanMessage),
        ("testBytesWithGreekMessage", testBytesWithGreekMessage),
        ("testBytesWithHungarianMessage", testBytesWithHungarianMessage),
        ("testBytesWithIcelandicMessage", testBytesWithIcelandicMessage),
        ("testBytesWithIrishGaelicMessage", testBytesWithIrishGaelicMessage),
        ("testBytesWithJapaneseMessage", testBytesWithJapaneseMessage),
        ("testBytesWithKatakanaMessage", testBytesWithKatakanaMessage),
        ("testBytesWithPolishMessage", testBytesWithPolishMessage),
        ("testBytesWithRussianMessage", testBytesWithRussianMessage),
        ("testBytesWithSpanishMessage", testBytesWithSpanishMessage),
        ("testBytesWithTurkishMessage", testBytesWithTurkishMessage),
    ]
}

extension TextFormatTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TextFormatTests = [
        ("testControlCharactersAbsentLeavesTheCharacters", testControlCharactersAbsentLeavesTheCharacters),
        ("testControlCharactersEscapeActuallyEscapes", testControlCharactersEscapeActuallyEscapes),
        ("testControlCharactersStripActuallyStrips", testControlCharactersStripActuallyStrips),
        ("testInitWithDateFormatter", testInitWithDateFormatter),
        ("testInitWithNoParameters", testInitWithNoParameters),
        ("testInitWithStripControlCharacters", testInitWithStripControlCharacters),
        ("testInitWithStripControlCharactersAndDateFormatter", testInitWithStripControlCharactersAndDateFormatter),
        ("testInitWithTemplate", testInitWithTemplate),
        ("testInitWithTerminator", testInitWithTerminator),
        ("testTemplateAllConstants", testTemplateAllConstants),
        ("testTemplateConstantsArePassedThrough", testTemplateConstantsArePassedThrough),
        ("testTemplateDate", testTemplateDate),
        ("testTemplateDefault", testTemplateDefault),
        ("testTemplateDoubleWrappedVariable", testTemplateDoubleWrappedVariable),
        ("testTemplateFile", testTemplateFile),
        ("testTemplateFunction", testTemplateFunction),
        ("testTemplateIncorrectVariables", testTemplateIncorrectVariables),
        ("testTemplateLevel", testTemplateLevel),
        ("testTemplateLine", testTemplateLine),
        ("testTemplateMessage", testTemplateMessage),
        ("testTemplateMessageWithEmbeddedMessageVariable", testTemplateMessageWithEmbeddedMessageVariable),
        ("testTemplateMessageWithEmbeddedVaraibles", testTemplateMessageWithEmbeddedVaraibles),
        ("testTemplateMessageWithEmbeddedVaraiblesReversed", testTemplateMessageWithEmbeddedVaraiblesReversed),
        ("testTemplateMultipleDate", testTemplateMultipleDate),
        ("testTemplateMultipleFile", testTemplateMultipleFile),
        ("testTemplateMultipleFunction", testTemplateMultipleFunction),
        ("testTemplateMultipleLevel", testTemplateMultipleLevel),
        ("testTemplateMultipleLine", testTemplateMultipleLine),
        ("testTemplateMultipleMessage", testTemplateMultipleMessage),
        ("testTemplateMultipleProcessIdentifier", testTemplateMultipleProcessIdentifier),
        ("testTemplateMultipleProcessName", testTemplateMultipleProcessName),
        ("testTemplateMultipleTag", testTemplateMultipleTag),
        ("testTemplateMultipleThreadIdentifier", testTemplateMultipleThreadIdentifier),
        ("testTemplateMultipleTimestamp", testTemplateMultipleTimestamp),
        ("testTemplateProcessIdentifier", testTemplateProcessIdentifier),
        ("testTemplateProcessName", testTemplateProcessName),
        ("testTemplateTag", testTemplateTag),
        ("testTemplateThreadIdentifier", testTemplateThreadIdentifier),
        ("testTemplateTimestamp", testTemplateTimestamp),
        ("testTemplateWithAllVariables", testTemplateWithAllVariables),
        ("testTemplateWithTabDelimited", testTemplateWithTabDelimited),
        ("testTerminatorCanBeSet", testTerminatorCanBeSet),
    ]
}

extension TraceLogPerformanceTestsSwift {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TraceLogPerformanceTestsSwift = [
        ("testLogErrorPerformance_NullWriter", testLogErrorPerformance_NullWriter),
        ("testLogTrace4Performance_NullWriter", testLogTrace4Performance_NullWriter),
    ]
}

extension TraceLogTestsSwift {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TraceLogTestsSwift = [
        ("testConfigureWithLogWriters", testConfigureWithLogWriters),
        ("testConfigureWithLogWritersAndEnvironment", testConfigureWithLogWritersAndEnvironment),
        ("testConfigureWithLogWritersAndEnvironmentGlobalInvalidLogLevel", testConfigureWithLogWritersAndEnvironmentGlobalInvalidLogLevel),
        ("testConfigureWithLogWritersAndEnvironmentPrefixInvalidLogLevel", testConfigureWithLogWritersAndEnvironmentPrefixInvalidLogLevel),
        ("testConfigureWithLogWritersAndEnvironmentTagInvalidLogLevel", testConfigureWithLogWritersAndEnvironmentTagInvalidLogLevel),
        ("testConfigureWithNoArgs", testConfigureWithNoArgs),
        ("testLogError", testLogError),
        ("testLogErrorWhileOff", testLogErrorWhileOff),
        ("testLogInfo", testLogInfo),
        ("testLogInfoWhileOff", testLogInfoWhileOff),
        ("testLogTrace", testLogTrace),
        ("testLogTrace1", testLogTrace1),
        ("testLogTrace1WhileOff", testLogTrace1WhileOff),
        ("testLogTrace2", testLogTrace2),
        ("testLogTrace2WhileOff", testLogTrace2WhileOff),
        ("testLogTrace3", testLogTrace3),
        ("testLogTrace3WhileOff", testLogTrace3WhileOff),
        ("testLogTrace4", testLogTrace4),
        ("testLogTrace4WhileOff", testLogTrace4WhileOff),
        ("testLogTraceWhileOff", testLogTraceWhileOff),
        ("testLogWarning", testLogWarning),
        ("testLogWarningWhileOff", testLogWarningWhileOff),
        ("testModeAsyncIsDifferentThread", testModeAsyncIsDifferentThread),
        ("testModeDirectIsSameThread", testModeDirectIsSameThread),
        ("testModeSyncBlocks", testModeSyncBlocks),
        ("testNoDeadLockAsyncMode", testNoDeadLockAsyncMode),
        ("testNoDeadLockDirectMode", testNoDeadLockDirectMode),
        ("testNoDeadLockSyncMode", testNoDeadLockSyncMode),
    ]
}

extension TraceLogWithFileWriterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TraceLogWithFileWriterTests = [
        ("testLogError", testLogError),
        ("testLogInfo", testLogInfo),
        ("testLogTrace1", testLogTrace1),
        ("testLogTrace2", testLogTrace2),
        ("testLogTrace3", testLogTrace3),
        ("testLogTrace4", testLogTrace4),
        ("testLogWarning", testLogWarning),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConfigurationTests.__allTests__ConfigurationTests),
        testCase(ConsoleWriterTests.__allTests__ConsoleWriterTests),
        testCase(EnvironmentTests.__allTests__EnvironmentTests),
        testCase(FileOutputStreamErrorPosixTests.__allTests__FileOutputStreamErrorPosixTests),
        testCase(FileOutputStreamTests.__allTests__FileOutputStreamTests),
        testCase(FileWriterInternalsTests.__allTests__FileWriterInternalsTests),
        testCase(FileWriterTests.__allTests__FileWriterTests),
        testCase(JSONFormatTests.__allTests__JSONFormatTests),
        testCase(MutexTests.__allTests__MutexTests),
        testCase(OutputStreamErrorPosixTests.__allTests__OutputStreamErrorPosixTests),
        testCase(RuntimeContextTests.__allTests__RuntimeContextTests),
        testCase(StandardStreamTests.__allTests__StandardStreamTests),
        testCase(StaticContextTests.__allTests__StaticContextTests),
        testCase(TextFormatEncodingWithUnicodeTests.__allTests__TextFormatEncodingWithUnicodeTests),
        testCase(TextFormatInternationalLanguagesTests.__allTests__TextFormatInternationalLanguagesTests),
        testCase(TextFormatTests.__allTests__TextFormatTests),
        testCase(TraceLogPerformanceTestsSwift.__allTests__TraceLogPerformanceTestsSwift),
        testCase(TraceLogTestsSwift.__allTests__TraceLogTestsSwift),
        testCase(TraceLogWithFileWriterTests.__allTests__TraceLogWithFileWriterTests),
    ]
}
#endif
