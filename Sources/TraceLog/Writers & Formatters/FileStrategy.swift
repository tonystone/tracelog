///
///  FileStrategy.swift
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
///  Created by Tony Stone on 1/31/19.
///
import Foundation

public enum FileStrategy {

    /// Default file strategy which creates a fixed
    /// file and reuses the same file on every startup.
    ///
    /// - Parameter fileName: The file name to use for the
    ///             logging file.  The file name should be
    ///             the name + any extension you would like
    ///             to use but should not include the path
    ///             component. Default is "trace.log".
    ///
    /// - Note: There are no points of file rotation
    ///         with this option, TraceLog will continue
    ///         to append to the file name specified.
    ///
    /// - Remark: Once Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md) is implemented
    ///           this will func will be changed to a case in the enum with default values.  We must
    ///           use a func now to work around the lack of defaults on enums.
    ///
    public static func fixed(fileName: String = Default.fileName) -> FileStrategy {
        return ._fixed(fileName: fileName)
    }

    /// A strategy that includes rotation of the files
    /// at various points in time (E.g. at startup,
    /// a max file size, or a certain age of the file.)
    ///
    /// - Parameters:
    ///     - at: A set of `RotationOption` values specifying
    ///           at what point to rotate the file that TraceLog
    ///           writes to. Default is `.startup`.
    ///     - template: A Unicode String pattern to use to uniquely
    ///                 name new files. Internally TraceLog uses
    ///                 `DateFormatter` to format the log file names
    ///                 which means you can use any DateFormatter
    ///                 legal format.  \
    ///                 \
    ///                 To ensure unique files during rotation, you
    ///                 must specify a format that includes a date
    ///                 component that will produce a unique file name
    ///                 for the granularity of file rotation. For instance
    ///                 passing "'trace-'yyyyMMdd'.log'" would give you 1
    ///                 day of granularity meaning that only one log
    ///                 file can be produced per day.
    ///                 \
    ///                 Default is "'trace-'yyyyMMdd-HHmm-ss.SSSS'.log'".
    ///                 \
    ///                 The default template is suitable for any practical
    ///                 rotation granularity.
    ///
    /// - Remark: Once Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md) is implemented
    ///           this func will be changed to a case in the enum with default values.  We must
    ///           use a func now to work around the lack of defaults on enums.
    ///
    public static func rotate(at options: Set<RotateOption> = Default.options, template: String = Default.template) -> FileStrategy {
        return ._rotate(at: options, template: template)
    }

    /// Options available for rotation strategy.
    ///
    public enum RotateOption {

        /// Rotate on startup of TraceLog
        ///
        case startup

        /// Rotate when the max file size reaches maxSize.
        ///
        case maxSize(UInt64)

        /// Rotate when the file reached a certain age.
        ///
        case age(days: Int)
    }

    /// - Warning: Internal, don't use directly. Use the versions with no underscore prefix
    ///            (`.fixed` and `.rotate`) instead. these cases will be removed at the end of the beta.
    ///
    /// - Remark: These are only here to allow us to have a beta and still provide the final
    ////          public interface with default parameters. We currently have no way of providing
    ///           default parameters to enum cases until Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md)
    ///           is implemented.
    case _fixed(fileName: String)
    case _rotate(at: Set<RotateOption>, template: String)
}

/// Default values for FileStrategy enum cases.
///
public extension FileStrategy {

    enum Default {

        /// Default file name for fixed file strategy.
        ///
        public static let fileName: String = "trace.log"

        /// Default option set for rotation strategy.
        ///
        public static let options: Set<RotateOption> = [.startup]

        /// Default template for rotation strategy.
        ///
        public static let template: String = "'trace-'yyyyMMdd-HHmm-ss.SSSS'.log'"
    }
}

/// Internal extension to allow use of a Set<RotationOption>
/// to ensure we only get one instance of each.
///
extension FileStrategy.RotateOption: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .startup:     hasher.combine(1); return
        case .maxSize(_):  hasher.combine(2); return
        case .age(_):      hasher.combine(3); return
        }
    }
}
