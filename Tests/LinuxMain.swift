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
   testCase(FileWriterTests.allTests),
   testCase(TraceLogWithFileWriterTests.allTests)
])

#endif
