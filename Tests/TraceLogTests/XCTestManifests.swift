import XCTest

extension ConfigurationTests {
    static let __allTests = [
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
    static let __allTests = [
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
    static let __allTests = [
        ("testInit", testInit),
        ("testInit_CollectionType", testInit_CollectionType),
        ("testInit_DictionaryLiteral", testInit_DictionaryLiteral),
        ("testSubscript", testSubscript),
    ]
}

extension FileWriterInternalsTests {
    static let __allTests = [
        ("testOpen", testOpen),
        ("testOpenCreatingDirectory", testOpenCreatingDirectory),
        ("testOpenFailure", testOpenFailure),
        ("testRotate", testRotate),
        ("testRotateFailure", testRotateFailure),
    ]
}

extension FileWriterTests {
    static let __allTests = [
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

extension MutexTests {
    static let __allTests = [
        ("testLockBlocked", testLockBlocked),
        ("testLockUnlock", testLockUnlock),
        ("testLockUnlockNonRecursiveBlocked", testLockUnlockNonRecursiveBlocked),
        ("testLockUnlockRecursive", testLockUnlockRecursive),
        ("testTryLockBlocked", testTryLockBlocked),
    ]
}

extension TextFormatTests {
    static let __allTests = [
        ("testInitWithDateFormatter", testInitWithDateFormatter),
        ("testInitWithNoParameters", testInitWithNoParameters),
        ("testInitWithStripControlCharacters", testInitWithStripControlCharacters),
        ("testInitWithStripControlCharactersAndDateFormatter", testInitWithStripControlCharactersAndDateFormatter),
        ("testInitWithTemplate", testInitWithTemplate),
        ("testInitWithTerminator", testInitWithTerminator),
        ("testStripControlCharactersFalseLeavesTheCharacters", testStripControlCharactersFalseLeavesTheCharacters),
        ("testStripControlCharactersTrueActuallyStrips", testStripControlCharactersTrueActuallyStrips),
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
        ("testTerminatorCanBeSet", testTerminatorCanBeSet),
    ]
}

extension TraceLogPerformanceTestsSwift {
    static let __allTests = [
        ("testLogErrorPerformance_NullWriter", testLogErrorPerformance_NullWriter),
        ("testLogTrace4Performance_NullWriter", testLogTrace4Performance_NullWriter),
    ]
}

extension TraceLogTestsSwift {
    static let __allTests = [
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
    static let __allTests = [
        ("testLogError", testLogError),
        ("testLogInfo", testLogInfo),
        ("testLogTrace1", testLogTrace1),
        ("testLogTrace2", testLogTrace2),
        ("testLogTrace3", testLogTrace3),
        ("testLogTrace4", testLogTrace4),
        ("testLogWarning", testLogWarning),
    ]
}

#if !canImport(ObjectiveC)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConfigurationTests.__allTests),
        testCase(ConsoleWriterTests.__allTests),
        testCase(EnvironmentTests.__allTests),
        testCase(FileWriterInternalsTests.__allTests),
        testCase(FileWriterTests.__allTests),
        testCase(MutexTests.__allTests),
        testCase(TextFormatTests.__allTests),
        testCase(TraceLogPerformanceTestsSwift.__allTests),
        testCase(TraceLogTestsSwift.__allTests),
        testCase(TraceLogWithFileWriterTests.__allTests),
    ]
}
#endif
