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

/// A FileOutputStream is an abstraction similar to a FileHandle
/// that represents the Output portion of the full file handle
/// interface.  At this writing TraceLog only requires writing of
/// files therefore, only the output portion was implemented.
///
/// - Remark: Why note just use `Foundation.FileHandle`?  We found
///           that the FileHandle implementation at this writing is
///           not suitable for TraceLog's stringent fault tolerance
///           requirements.  The current implementation of the
///           FileHandle.write function, and others, call `FatalError()`
///           (crashing your app) if any error is encountered when
///           writing to the file.  This is not acceptable behavior
///           so we wrote our own implementation so that TraceLog can
///           recover gracefully when writes and other operations fail.
///
internal class FileOutputStream {

    /// Additional options for opening the file.
    ///
    struct OpenOptions: OptionSet {

        /// Create the file if it does not exist.
        ///
        static let create  = OpenOptions(rawValue: O_CREAT)

        /// Fail if `.create` is passed and the file already exists.
        ///
        static let exclusive = OpenOptions(rawValue: O_EXCL)

        /// Truncate the file when opening an existing file.
        ///
        static let truncate = OpenOptions(rawValue: O_TRUNC)

        let rawValue: Int32
    }

    /// Initialize an instance of self for the file at URL.
    ///
    /// Files opened with this method are always opened for WRITE ONLY
    /// and APPEND mode since this is an OutputStream.  You can pass
    /// additional open options using the options parameter.
    ///
    /// - Parameters:
    ///     - url: The URL of the file to be opened.
    ///     - options:
    ///
    /// - Throws: A FileOutputStreamError type.
    ///
    /// - SeeAlso: FileOutputStreamError
    ///
    convenience init(url: URL, options: OpenOptions = [], mode: mode_t = (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) throws {

        /// Open the file at the URL for write and append since this
        /// is specifically an OutputStream.
        ///
        let descriptor = url.path.withCString { open($0, O_WRONLY | O_APPEND | options.rawValue, mode) }

        guard descriptor != -1
            else { throw FileOutputStreamError.error(for: errno) }

        self.init(fileDescriptor: descriptor, closeFd: true)
    }

    /// Designated initializer for this class.
    ///
    /// It is private to control the File descriptors that
    /// can be passed to this class, limiting it to stdout, stderr,
    /// and standard files types that can be opened with the
    /// convenience initializers accepting a URL.
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
    private var fd: Int32

    /// Should we close this file descriptor on deinit and on request or not.
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

        /// If its any of the std descriptors or below
        /// position is not supported and always returns 0.
        ///
        guard self.fd > STDERR_FILENO
            else { return 0 }

        let offset = lseek(self.fd, 0, SEEK_CUR)

        /// Terminal or pipe stream which does not support positioning.
        guard offset != -1 && errno != EPIPE
            else { return 0 }

        return UInt64(offset)
    }

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

        var buffer = UnsafePointer(bytes)
        var length = bytes.count

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

// Private extension to work around Swifts confusion around similar function names.
///
private extension FileOutputStream {

    @inline(__always)
    func write(_ fd: Int32, _ buffer: UnsafePointer<UInt8>, _ nbytes: Int) -> Int {
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

extension FileOutputStream: Equatable {
    static func == (lhs: FileOutputStream, rhs: FileOutputStream) -> Bool {
        return lhs.fd == rhs.fd && lhs.closeFd == rhs.closeFd
    }
}

/// Specific FileOutputStream errors.
///
internal enum FileOutputStreamError: Error {

    /// File already exists and could not be created.
    ///
    case fileExists(String)

    /// Access tot he file was denied.
    ///
    case accessDenied(String)

    /// An invalid URL was specified
    ///
    case invalidURL(String)

    /// An unknown error occurred.
    ///
    case unknownError(Int32, String)
}
