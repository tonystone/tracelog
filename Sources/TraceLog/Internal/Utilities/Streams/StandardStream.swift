///
///  StandardStream.swift
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
#if os(macOS) || os(iOS)
    import Darwin
#elseif os(Linux) || CYGWIN
    import Glibc
#endif

/// Standard Streams for input and output to the console.
///
internal enum Standard {

    /// Standard output (stdout)
    ///
    static var out: FileOutputStream {  // FIXME: change to OutputStream
        return FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false)
    }

    /// Standard error (stderr)
    ///
    static var error: FileOutputStream {  // FIXME: change to OutputStream
        return FileOutputStream(fileDescriptor: STDERR_FILENO, closeFd: false)
    }
}
