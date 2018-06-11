/// build-tools: auto-generated

#if os(Linux) || os(FreeBSD)

import XCTest

@testable import TraceLogTests

XCTMain([
   testCase(TraceLogPerformanceTestsSwift.allTests),
   testCase(TraceLogTestsSwift.allTests),
   testCase(EnvironmentTests.allTests),
   testCase(ConfigurationTests.allTests)
])

extension TraceLogPerformanceTestsSwift {

   static var allTests: [(String, (TraceLogPerformanceTestsSwift) -> () throws -> Void)] {
      return [
                ("testLogErrorPerformance_NullWriter", testLogErrorPerformance_NullWriter),
                ("testLogTrace4Performance_NullWriter", testLogTrace4Performance_NullWriter)
           ]
   }
}

extension TraceLogTestsSwift {

   static var allTests: [(String, (TraceLogTestsSwift) -> () throws -> Void)] {
      return [
                ("testConfigureWithNoArgs", testConfigureWithNoArgs),
                ("testConfigureWithLogWriters", testConfigureWithLogWriters),
                ("testConfigureWithLogWritersAndEnvironment", testConfigureWithLogWritersAndEnvironment),
                ("testConfigureWithLogWritersAndEnvironmentGlobalInvalidLogLevel", testConfigureWithLogWritersAndEnvironmentGlobalInvalidLogLevel),
                ("testConfigureWithLogWritersAndEnvironmentPrefixInvalidLogLevel", testConfigureWithLogWritersAndEnvironmentPrefixInvalidLogLevel),
                ("testConfigureWithLogWritersAndEnvironmentTagInvalidLogLevel", testConfigureWithLogWritersAndEnvironmentTagInvalidLogLevel),
                ("testLogError", testLogError),
                ("testLogWarning", testLogWarning),
                ("testLogInfo", testLogInfo),
                ("testLogTrace", testLogTrace),
                ("testLogTrace1", testLogTrace1),
                ("testLogTrace2", testLogTrace2),
                ("testLogTrace3", testLogTrace3),
                ("testLogTrace4", testLogTrace4),
                ("testLogErrorWhileOff", testLogErrorWhileOff),
                ("testLogWarningWhileOff", testLogWarningWhileOff),
                ("testLogInfoWhileOff", testLogInfoWhileOff),
                ("testLogTraceWhileOff", testLogTraceWhileOff),
                ("testLogTrace1WhileOff", testLogTrace1WhileOff),
                ("testLogTrace2WhileOff", testLogTrace2WhileOff),
                ("testLogTrace3WhileOff", testLogTrace3WhileOff),
                ("testLogTrace4WhileOff", testLogTrace4WhileOff)
           ]
   }
}

extension EnvironmentTests {

   static var allTests: [(String, (EnvironmentTests) -> () throws -> Void)] {
      return [
                ("testInit", testInit),
                ("testInit_DictionaryLiteral", testInit_DictionaryLiteral),
                ("testInit_CollectionType", testInit_CollectionType),
                ("testSubscript", testSubscript)
           ]
   }
}

extension ConfigurationTests {

   static var allTests: [(String, (ConfigurationTests) -> () throws -> Void)] {
      return [
                ("testInit", testInit),
                ("testLoad_Prefixes", testLoad_Prefixes),
                ("testLoad_Tags", testLoad_Tags),
                ("testLogLevel_All_Default", testLogLevel_All_Default),
                ("testLogLevel_All_Set", testLogLevel_All_Set),
                ("testLogLevel_All_Set_Off", testLogLevel_All_Set_Off),
                ("testLogLevel_All_Set_Error", testLogLevel_All_Set_Error),
                ("testLogLevel_All_Set_Warning", testLogLevel_All_Set_Warning),
                ("testLogLevel_All_Set_Info", testLogLevel_All_Set_Info),
                ("testLogLevel_All_Set_Trace1", testLogLevel_All_Set_Trace1),
                ("testLogLevel_All_Set_Trace2", testLogLevel_All_Set_Trace2),
                ("testLogLevel_All_Set_Trace3", testLogLevel_All_Set_Trace3),
                ("testLogLevel_All_Set_Trace4", testLogLevel_All_Set_Trace4),
                ("testLogLevel_All_Set_InvalidLevel", testLogLevel_All_Set_InvalidLevel),
                ("testLogLevel_Prefix", testLogLevel_Prefix),
                ("testLogLevel_Tag", testLogLevel_Tag)
           ]
   }
}

#endif
