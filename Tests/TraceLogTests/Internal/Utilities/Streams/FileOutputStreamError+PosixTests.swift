///
///  FileOutputStreamErrorPosixTests.swift
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


class FileOutputStreamErrorPosixTests: XCTestCase {

    func testErrorForOutOfRangeCode() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: -1) {
            XCTAssertEqual(code, -1)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEROFS() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .accessDenied(_) = FileOutputStreamError.error(for: EROFS)
            else { XCTFail(".accessDenied was expected"); return }
    }

    func testErrorForEACCES() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .accessDenied(_) = FileOutputStreamError.error(for: EACCES)
            else { XCTFail(".accessDenied was expected"); return }
    }

    func testErrorForEEXIST() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .fileExists(_) = FileOutputStreamError.error(for: EEXIST)
            else { XCTFail(".fileExists was expected"); return }
    }

    func testErrorForENAMETOOLONG() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ENAMETOOLONG)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForENOENT() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ENOENT)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForENOSPC() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ENOSPC)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForENOTDIR() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ENOTDIR)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForELOOP() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ELOOP)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForENOSR() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ENOSR)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForENXIO() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: ENXIO)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForEISDIR() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        guard case .invalidURL(_) = FileOutputStreamError.error(for: EISDIR)
            else { XCTFail(".invalidURL was expected"); return }
    }

    func testErrorForEAGAIN() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: EAGAIN) {
            XCTAssertEqual(code, EAGAIN)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForENOMEM() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: ENOMEM) {
            XCTAssertEqual(code, ENOMEM)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEIO() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: EIO) {
            XCTAssertEqual(code, EIO)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEINVAL() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: EINVAL) {
            XCTAssertEqual(code, EINVAL)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEOVERFLOW() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: EOVERFLOW) {
            XCTAssertEqual(code, EOVERFLOW)
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
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: EINTR) {
            XCTAssertEqual(code, EINTR)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForEMFILE() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: EMFILE) {
            XCTAssertEqual(code, EMFILE)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForETXTBSY() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: ETXTBSY) {
            XCTAssertEqual(code, ETXTBSY)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

    func testErrorForENFILE() {

        /// Note: We rely on the strerror(errno) from the system
        /// to provide the actual message so we ignore it in these
        /// tests at the moment.  IN the current implementation
        /// of Swift the message is slightly different between
        /// Darwin and Linux.
        ///
        if case .unknownError(let code, _) = FileOutputStreamError.error(for: ENFILE) {
            XCTAssertEqual(code, ENFILE)
        } else {
            XCTFail(".unknownError was expected")
        }
    }

}
