///
///  FileOutputStream.swift
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
///  Created by Tony Stone on 1/14/19.
///
import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux) || CYGWIN
    import Glibc
#endif

/// A safe version of an OutputStream for file writing.
///
internal class FileOutputStream {

    /// Specific FileOutputStream errors.
    ///
    enum FileStreamError: Error {

        /// The open operation failed.
        ///
        case openFailed(Int32, String)
    }

    /// Designated initializer for this class.
    ///
    init(fileDescriptor: Int32, closeFd: Bool) {
        self.fd      = fileDescriptor
        self.closeFd = closeFd
    }

    /// Initialize an instance of self for the file at URL.
    ///
    convenience init(url: URL) throws {

        /// Open the file at the URL for write since this
        /// is specifically an OutputStream.
        let descriptor = url.path.withCString { open($0, O_WRONLY) }

        guard descriptor != -1
            else { throw FileStreamError.openFailed(errno, String(cString: strerror(errno))) }

        /// We are a stream so we need to make sure we are at end of file.
        lseek(descriptor, 0, SEEK_END)

        self.init(fileDescriptor: descriptor, closeFd: true)
    }

    deinit {
        self.close()
    }

    /// Close the file.
    ///
    func close() {
        if self.fd >= 0 && closeFd {
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            Darwin.close(self.fd)
        #elseif os(Linux) || CYGWIN
            Glibc.close(self.fd)
        #endif
            self.fd = -1
        }
    }

    /// The file descriptor assiciated with this OutputStream.
    ///
    private var fd: Int32

    /// Should we close this file descriptor on deinit and on request or not.
    ///
    /// If this is system stream such as stdout, then you don't want
    /// to close it so pass false.
    ///
    private let closeFd: Bool

}

/// OutputStream conformance for FileOutputStream.
///
extension FileOutputStream: OutputStream {

    /// The current write position or number of bytes
    /// written to the stream.
    ///
    var position: UInt64 {
        guard self.fd >= 0
            else { return 0 }

        return UInt64(lseek(self.fd, 0, SEEK_CUR))
    }

    /// Writes the byte block to the File.
    ///
    func write(_ bytes: [UInt8]) -> Result<Int, OutputStreamError> {

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            let written = Darwin.write(self.fd, UnsafePointer(bytes), bytes.count)
        #elseif os(Linux) || CYGWIN
            let written = Glibc.write(self.fd, UnsafePointer(bytes), bytes.count)
        #endif

        guard written != -1
            else { return .failure(.writeFailed(errno, String(cString: strerror(errno)))) }

        return .success(written)
    }
}

extension FileOutputStream: Equatable {
    static func == (lhs: FileOutputStream, rhs: FileOutputStream) -> Bool {
        return lhs.fd == rhs.fd && lhs.closeFd == rhs.closeFd
    }
}
