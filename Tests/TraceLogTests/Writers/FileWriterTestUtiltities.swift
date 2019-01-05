///
/// FileWriterTestUtiltities.swift
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
///  Created by Tony Stone on 7/14/18.
///
import Foundation

///
/// Test for the existence of a log file archive
///
internal func archiveExists(fileName: String, fileExt: String, directory: String) throws -> Bool {

    /// Default file date is: "yyyyMMdd-HHmm-ss-SSS"
    let regex = try NSRegularExpression(pattern: "\(fileName)-(\\d{4}\\d{2}\\d{2}-\\d{2}\\d{2}-\\d{2}\\-\\d{3}).\(fileExt)")

    for file in try FileManager.default.contentsOfDirectory(atPath: directory) {
        if regex.firstMatch(in: file, range: NSRange(file.startIndex..., in: file)) != nil {
            return true
        }
    }
    return false
}
