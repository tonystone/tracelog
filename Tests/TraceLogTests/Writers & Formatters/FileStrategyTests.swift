//
//  FileStrategyTests.swift
//  TraceLogTests
//
//  Created by Tony Stone on 2/2/19.
//

import XCTest

import TraceLog

class FileStrategyTests: XCTestCase {

    // MARK: - Public Interface Compatibility Tests

    /// Note: These tests failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testFileStrategyDefaultWithDefaultParameters() {
        guard case FileStrategy._fixed(fileName: "trace.log") = FileStrategy.fixed()
            else { XCTFail(); return }
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testFileStrategyRotateWithDefaultParameters() {
        guard case FileStrategy._rotate(at: [.startup], template: "'trace-'yyyyMMdd-HHmm-ss.SSSS'.log'") = FileStrategy.rotate(at: [.startup])
            else { XCTFail(); return }
    }
}
