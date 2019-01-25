///
///  OutputStreamError+Posix.swift
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
import Foundation

internal extension OutputStreamError {

    /// Translate from an errno to a OutputStreamError
    ///
    static func error(for errorNumber: Int32) -> OutputStreamError {
        let message = String(cString: strerror(errorNumber))

        switch errorNumber {
        case ENETDOWN,    /// A write was attempted on a socket and the local network interface used to reach the destination is down.
             ENETUNREACH: /// A write was attempted on a socket and no route to the network is present.
            return .networkDown(message)

        case EBADF,       /// The fd argument is not a valid file descriptor open for writing.
             EPIPE,       /// A write was attempted on a socket that is shut down for writing, or is no longer connected. In the latter case, if the socket is of type SOCK_STREAM, a SIGPIPE signal shall also be sent to the thread.
             ECONNRESET,  /// A write was attempted on a socket that is not connected.
             ENXIO,       /// A hangup occurred on the STREAM being written to.
             EIO:         /// The process is a member of a background process group attempting to write to its controlling terminal, TOSTOP is set, the process is neither ignoring nor blocking SIGTTOU, and the process group of the process is orphaned. This error may also be returned under implementation-defined conditions.
            return .disconnected(message)

        case ENOSPC,  /// There was no free space remaining on the device containing the file.
             ERANGE,  /// The transfer request size was outside the range supported by the STREAMS file associated with fd.
             EFBIG,   /// An attempt was made to write a file that exceeds the implementation-defined maximum file size or the process' file size limit,  and there was no room for any bytes to be written.
                      /// or The file is a regular file, nbyte is greater than 0, and the starting position is greater than or equal to the offset maximum established in the open file description associated with fd.
             ENOBUFS: /// Insufficient resources were available in the system to perform the operation.
            return .insufficientResources(message)

        case EACCES:    /// A write was attempted on a socket and the calling process does not have appropriate privileges.
            return .accessDenied(message)

        case EINVAL:   /// The STREAM or multiplexer referenced by fd is linked (directly or indirectly) downstream from a multiplexer.
            return .invalidArgument(message)

        case EAGAIN, EWOULDBLOCK, /// The file descriptor is for a socket, is marked O_NONBLOCK, and write would block.
             EINTR:               /// The write operation was terminated due to the receipt of a signal, and no data was transferred.
            fallthrough
        default:
            return .unknownError(errorNumber, message)
        }
    }
}
