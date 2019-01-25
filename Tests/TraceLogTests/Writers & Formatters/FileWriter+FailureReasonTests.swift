///
///  FileWriter+FailureReasonTests.swift
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
import TraceLogTestHarness

@testable import TraceLog


class FileWriterFailureReasonTests: XCTestCase {

    func testErrorForNetworkdown() {

        guard case .unavailable = FailureReason(.networkDown("Network down"))
            else { XCTFail(".unavailable was expected"); return }
    }

    func testErrorForDisconnected() {

        guard case .unavailable = FailureReason(.disconnected("Disconnected"))
            else { XCTFail(".unavailable was expected"); return }
    }

    func testErrorForInsufficientresources() {

        guard case .error = FailureReason(.insufficientResources("Insufficient resources"))
            else { XCTFail(".error was expected"); return }
    }

    func testErrorForAccessdenied() {

        guard case .error = FailureReason(.accessDenied("Access denied"))
            else { XCTFail(".error was expected"); return }
    }

    func testErrorForInvalidargument() {

        guard case .error = FailureReason(.invalidArgument("Invalid argument"))
            else { XCTFail(".error was expected"); return }
    }

    func testErrorForUnknownerror() {

        guard case .error = FailureReason(.unknownError(10, "Unknown error" ))
            else { XCTFail(".error was expected"); return }
    }

}
