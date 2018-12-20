/// build-tools: auto-generated

#if os(Linux) || os(FreeBSD)

import XCTest

@testable import TraceLogTests
@testable import TraceLogTestHarnessTests

XCTMain([
   testCase(TraceLogPerformanceTestsSwift.allTests),
   testCase(TraceLogTestsSwift.allTests),
   testCase(EnvironmentTests.allTests),
   testCase(ConfigurationTests.allTests),
   testCase(TestHarnessTests.allTests),
   testCase(TestUtilitiesTests.allTests),
   testCase(AnyReaderTests.allTests),
   testCase(TestUtilitiesTests.allTests),
   testCase(ConsoleWriterTests.allTests),
   testCase(FileWriterTests.allTests),
   testCase(FileWriterInternalsTests.allTests),
   testCase(TraceLogWithFileWriterTests.allTests),
   testCase(MutexTests.allTests),
   testCase(BlockTimerTests.allTests),
   testCase(AsyncWriterProxyTests.allTests),
   testCase(SyncWriterProxyTests.allTests),
   testCase(RuntimeContextTests.allTests),
   testCase(StaticContextTests.allTests),
   testCase(WriterTests.allTests),
])

#endif
