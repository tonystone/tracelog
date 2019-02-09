///
///  FilerWriter.swift
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
///  Created by Tony Stone on 6/27/18.
///
import Foundation

extension FileWriter {

    /// Defaults for init values
    ///
    public enum Default {

        /// The default strategy for the FileWriter is the fixed strategy with a
        /// file name of "trace.log".
        ///
        public static let strategy: FileStrategy = .fixed(fileName: "trace.log")

        /// Default format.
        ///
        public static let format: OutputStreamFormatter = TextFormat()
    }
}

/// File `Writer` which writes log output to an os file.
///
public class FileWriter: OutputStreamWriter {

    /// OutputStreamFormatter being used for formating output.
    ///
    public let format: OutputStreamFormatter

    /// Default constructor for this writer
    ///
    public init(directory: URL, strategy: FileStrategy = Default.strategy, format: OutputStreamFormatter = Default.format) throws {
        self.format = format

        /// Ensure we have a directory URL so that relative paths are resolved correctly.
        ///
        let directory = URL(fileURLWithPath: directory.path, isDirectory: true)

        /// Create the directory if required.
        try createDirectory(url: directory)

        switch strategy {
        case ._fixed(let fileName):
            self.fileManager = try FileStrategyFixed(directory:  directory, fileName: fileName)
        case ._rotate(let options, let template):
            self.fileManager = try FileStrategyRotate(directory: directory, template: template, options: options)
        }
    }

    /// Required write function for the logger
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {

        let result = format.bytes(from: entry)

        guard case .success(let bytes) = result
            else { return result.map({ (_) in 0 }).mapError({ .error($0) })  }

        /// Write message to log
        ///
        return self.fileManager.write(bytes)
    }

    internal /* @testable */
    var currentFileURL: URL {
        return self.fileManager.url
    }

    /// The currently open log file handle and configuration.
    ///
    private var fileManager: FileStrategyManager

}

private func createDirectory(url: URL) throws {
    do {
        try Foundation.FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        throw FileOutputStreamError.invalidURL(error.localizedDescription)
    }
}
