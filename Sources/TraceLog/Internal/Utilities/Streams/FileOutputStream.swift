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
internal class FileOutputStream: RawOutputStream {

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

    struct Mode: OptionSet {

        /// Readable by user.
        static let readUser = Mode(rawValue: S_IRUSR)

        /// Writable by user.
        static let writeUser = Mode(rawValue: S_IWUSR)

        /// Executable by user.
        static let executeUser = Mode(rawValue: S_IXUSR)

        /// Readable by group.
        static let readGroup = Mode(rawValue: S_IRGRP)

        /// Writable by group.
        static let writeGroup = Mode(rawValue: S_IWGRP)

        /// Executable by group.
        static let executeGroup = Mode(rawValue: S_IXGRP)

        /// Readable by others.
        static let readOther = Mode(rawValue: S_IROTH)

        /// Writable by others.
        static let writeOther = Mode(rawValue: S_IWOTH)

        /// Executable by others.
        static let executeOther = Mode(rawValue: S_IXOTH)

        let rawValue: mode_t
    }

    /// The url this file stream was opened with.
    ///
    let url: URL

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
    init(url: URL, options: OpenOptions = [], mode: Mode = [.readUser, .writeUser, .readGroup, .readOther]) throws {

        /// Open the file at the URL for write and append since this
        /// is specifically an OutputStream.
        ///
        let descriptor = url.path.withCString { open($0, O_WRONLY | O_APPEND | options.rawValue, mode.rawValue) }

        guard descriptor != -1
            else { throw FileOutputStreamError.error(for: errno) }

        self.url = url

        super.init(fileDescriptor: descriptor, closeFd: true)
    }

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
