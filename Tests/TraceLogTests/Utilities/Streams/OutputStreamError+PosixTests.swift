///
///  OutputStreamErrorPosixTests.swift
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
///  Created by Tony Stone on 1/17/19.
///
import XCTest

@testable import TraceLog

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux) || CYGWIN
    import Glibc
#endif

class OutputStreamErrorPosixTests: XCTestCase {

    func testErrorForOutOfRangeCode() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = OutputStreamError.error(for: -1) {
            XCTAssertEqual(code, -1)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForENETDOWN() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .networkDown(_) = OutputStreamError.error(for: ENETDOWN)
            else { XCTFail(".networkDown was expected"); return }
    }

    func testErrorForENETUNREACH() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .networkDown(_) = OutputStreamError.error(for: ENETUNREACH)
            else { XCTFail(".networkDown was expected"); return }
    }

    func testErrorForEBADF() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .disconnected(_) = OutputStreamError.error(for: EBADF)
            else { XCTFail(".disconnected was expected"); return }
    }

    func testErrorForEPIPE() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .disconnected(_) = OutputStreamError.error(for: EPIPE)
            else { XCTFail(".disconnected was expected"); return }
    }

    func testErrorForECONNRESET() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .disconnected(_) = OutputStreamError.error(for: ECONNRESET)
            else { XCTFail(".disconnected was expected"); return }
    }

    func testErrorForENXIO() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .disconnected(_) = OutputStreamError.error(for: ENXIO)
            else { XCTFail(".disconnected was expected"); return }
    }

    func testErrorForEIO() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .disconnected(_) = OutputStreamError.error(for: EIO)
            else { XCTFail(".disconnected was expected"); return }
    }

    func testErrorForENOSPC() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .insufficientResources(_) = OutputStreamError.error(for: ENOSPC)
            else { XCTFail(".insufficientResources was expected"); return }
    }

    func testErrorForERANGE() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .insufficientResources(_) = OutputStreamError.error(for: ERANGE)
            else { XCTFail(".insufficientResources was expected"); return }
    }

    func testErrorForEFBIG() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .insufficientResources(_) = OutputStreamError.error(for: EFBIG)
            else { XCTFail(".insufficientResources was expected"); return }
    }

    func testErrorForENOBUFS() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .insufficientResources(_) = OutputStreamError.error(for: ENOBUFS)
            else { XCTFail(".insufficientResources was expected"); return }
    }

    func testErrorForEACCES() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .accessDenied(_) = OutputStreamError.error(for: EACCES)
            else { XCTFail(".accessDenied was expected"); return }
    }

    func testErrorForEINVAL() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidArgument(_) = OutputStreamError.error(for: EINVAL)
            else { XCTFail(".invalidArgument was expected"); return }
    }

    func testErrorForEAGAIN() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = OutputStreamError.error(for: EAGAIN) {
            XCTAssertEqual(code, EAGAIN)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEWOULDBLOCK() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = OutputStreamError.error(for: EWOULDBLOCK) {
            XCTAssertEqual(code, EWOULDBLOCK)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEINTR() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = OutputStreamError.error(for: EINTR) {
            XCTAssertEqual(code, EINTR)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

}
