///
///  FileStrategyManager+FailureReasonTests.swift
///
///  Copyright 2019 Tony Stone
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
///  Created by Tony Stone on 1/24/19.
///
import XCTest

@testable import TraceLog


class FileStrategyManagerFailureReasonTests: XCTestCase {

    class TestFileStrategyManager: FileStrategyManager {
        var url: URL { return URL(fileURLWithPath: "//dev/nul") }

        func write(_ bytes: [UInt8]) -> Result<Int, FailureReason> {
            return .success(0)
        }
    }

    func testErrorForNetworkdown() {

        guard case .unavailable = TestFileStrategyManager().failureReason(.networkDown("Network down"))
            else { XCTFail(".unavailable was expected"); return }
    }

    func testErrorForDisconnected() {

        guard case .unavailable = TestFileStrategyManager().failureReason(.disconnected("Disconnected"))
            else { XCTFail(".unavailable was expected"); return }
    }

    func testErrorForInsufficientresources() {

        guard case .error = TestFileStrategyManager().failureReason(.insufficientResources("Insufficient resources"))
            else { XCTFail(".error was expected"); return }
    }

    func testErrorForAccessdenied() {

        guard case .error = TestFileStrategyManager().failureReason(.accessDenied("Access denied"))
            else { XCTFail(".error was expected"); return }
    }

    func testErrorForInvalidargument() {

        guard case .error = TestFileStrategyManager().failureReason(.invalidArgument("Invalid argument"))
            else { XCTFail(".error was expected"); return }
    }

    func testErrorForUnknownerror() {

        guard case .error = TestFileStrategyManager().failureReason(.unknownError(10, "Unknown error" ))
            else { XCTFail(".error was expected"); return }
    }

}
