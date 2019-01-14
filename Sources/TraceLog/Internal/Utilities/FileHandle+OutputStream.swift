///
///  TextFormat.swift
///
///  Copyright 2018 Tony Stone
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
///  Created by Tony Stone on 12/29/18.
///
import Foundation

/// Conform FileHandle to OutputStream for use
/// in writing general collections of bytes.
///
extension FileHandle: OutputStream {

    public func write(_ bytes: [UInt8]) {
        self.write(Data(bytes))
    }
}
