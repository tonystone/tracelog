///
///  RawOutputStream.swift
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
///  Created by Tony Stone on 1/27/19.
///
import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux) || CYGWIN
    import Glibc
#endif

internal class RawOutputStream {
    
    /// Designated initializer for this class.
    ///
    /// - Parameters:
    ///     - fileDescriptor: The file descriptor associated with this OutputStream.
    ///     - closeFd: Should we close this file descriptor on deinit and on request or not. If this is system stream such as stdout, then you don't want to close it so pass false.
    ///
    internal /* @testable and for use with Standard only */
    init(fileDescriptor: Int32, closeFd: Bool) {
        self.fd      = fileDescriptor
        self.closeFd = closeFd
    }

    deinit {
        self.close()
    }

    /// Close the file.
    ///
    func close() {
        if self.fd >= 0 && closeFd {
            self.close(self.fd)
            self.fd = -1
        }
    }

    /// The file descriptor associated with this OutputStream.
    ///
    internal var fd: Int32

    /// Should we close this file descriptor on deinit and on request or not.
    ///
    private let closeFd: Bool
}

/// OutputStream conformance for FileOutputStream.
///
extension RawOutputStream: OutputStream {

    /// Writes the byte block to the File.
    ///
    /// - Note: We are forgoing locking of the file here since we write the data
    ///         nearly 100% of the time in a single write() call. POSIX guarantees that
    ///         if the file is opened in append mode, individual write() operations will
    ///         be atomic. Partial writes are the only time that we can't write in a
    ///         single call but with the minimal write sizes that are written, these
    ///         will be almost non-existent.
    ///         \
    ///         Per the [POSIX standard](http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html):
    ///         \
    ///         "If the O_APPEND flag of the file status flags is set, the file offset
    ///         shall be set to the end of the file prior to each write and no intervening
    ///         file modification operation shall occur between changing the file offset
    ///         and the write operation."
    ///
    func write(_ bytes: [UInt8]) -> Result<Int, OutputStreamError> {

        return bytes.withUnsafeBytes { (bufferPointer) -> Result<Int, OutputStreamError> in

            guard var buffer = bufferPointer.baseAddress
                else { return .failure(.invalidArgument("byte buffer empty, can not write.")) }

            var length = bufferPointer.count

            var written: Int = 0

            /// Handle partial writes.
            ///
            repeat {
                written = self.write(self.fd, buffer, length)

                if written == -1 {
                    if errno == EINTR { /// Always retry if interrupted.
                        continue
                    }
                    return .failure(OutputStreamError.error(for: errno))
                }
                length -= written
                buffer += written

                /// Exit if there are no more bytes (length != 0) or
                /// we wrote zero bytes (written != 0)
                ///
            } while (length != 0 && written != 0)

            return .success(written)
        }
    }
}

/// Private extension to work around Swifts confusion around similar function names.
///
internal extension RawOutputStream {

    @inline(__always)
    func write(_ fd: Int32, _ buffer: UnsafeRawPointer, _ nbytes: Int) -> Int {
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            return Darwin.write(fd, buffer, nbytes)
        #elseif os(Linux) || CYGWIN
            return Glibc.write(fd, buffer, nbytes)
        #endif
    }

    @inline(__always)
    func close(_ fd: Int32) {
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            Darwin.close(fd)
        #elseif os(Linux) || CYGWIN
            Glibc.close(fd)
        #endif
    }
}
