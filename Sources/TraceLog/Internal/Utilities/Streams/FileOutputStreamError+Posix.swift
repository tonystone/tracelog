///
///  FileOutputStreamError+Posix.swift
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
///  Created by Tony Stone on 1/18/19.
///
import Foundation

extension FileOutputStreamError {

        /// Translate from an errno to a FileOutputStreamError
        ///
        static func error(for errorNumber: Int32) -> FileOutputStreamError {
            let message = String(cString: strerror(errorNumber))

            switch errorNumber {

            case EROFS,         /// The named file resides on a read-only file system and either O_WRONLY, O_RDWR, O_CREAT (if the file does not exist), or O_TRUNC is set in the oflag argument.
                 EACCES:        /// Search permission is denied on a component of the path prefix, or the file exists and the permissions specified by oflag are denied, or the file does not exist and write permission is denied for the parent directory of the file to be created, or O_TRUNC is specified and write permission is denied.
                return .accessDenied(message)

            case EEXIST:        /// O_CREAT and O_EXCL are set, and the named file exists.
                return .fileExists(message)

            case ENAMETOOLONG,  /// As a result of encountering a symbolic link in resolution of the path argument, the length of the substituted pathname string exceeded {PATH_MAX}, or The length of the path argument exceeds {PATH_MAX} or a pathname component is longer than {NAME_MAX}.
                 ENOENT,        /// O_CREAT is not set and the named file does not exist; or O_CREAT is set and either the path prefix does not exist or the path argument points to an empty string.
                 ENOSPC,        /// The directory or file system that would contain the new file cannot be expanded, the file does not exist, and O_CREAT is specified.
                 ENOTDIR,       /// A component of the path prefix is not a directory.
                 ELOOP,         /// A loop exists in symbolic links encountered during resolution of the path argument.
                 ENOSR,         /// The path argument names a STREAMS-based file and the system is unable to allocate a STREAM.
                 ENXIO,         /// The named file is a character special or block special file, and the device associated with this special file does not exist.
                 EISDIR:        /// The named file is a directory and oflag includes O_WRONLY or O_RDWR.
                return .invalidURL(message)

            case EAGAIN,         /// The path argument names the slave side of a pseudo-terminal device that is locked.
                 ENOMEM,         /// The path argument names a STREAMS file and the system is unable to allocate resources.
                 EIO,            /// The path argument names a STREAMS file and a hangup or error occurred during the open().
                 EINVAL,         /// The value of the oflag argument is not valid, or The implementation does not support synchronized I/O for this file.
                 EOVERFLOW,      /// The named file is a regular file and the size of the file cannot be represented correctly in an object of type off_t.
                 EINTR,          /// A signal was caught during open().
                 EMFILE,         /// {OPEN_MAX} file descriptors are currently open in the calling process.
                 ETXTBSY,        /// The file is a pure procedure (shared text) file that is being executed and oflag is O_WRONLY or O_RDWR.
                 ENFILE:         /// The maximum allowable number of files is currently open in the system.
                fallthrough

            default:
                return .unknownError(errorNumber, message)
            }
        }
}
