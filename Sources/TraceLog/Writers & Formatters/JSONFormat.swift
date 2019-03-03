///
///  JSONFormat.swift
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
///  Created by Tony Stone on 12/26/18.
///
import Foundation

/// The JSONFormat is a configurable implementation of a `OutputStreamFormatter`
/// which outputs standard JSON as it's output.
///
/// Since the JSONFormat is an instance of `OutputStreamFormatter` it can be
/// used with any `Writer` that accepts the `OutputStreamFormatter` on construction.
///
/// JSONFormat has a number of options for configuring it for many use-cases.  All
/// options have a default value assigned to them to make it easy to get started
/// without configuration. Should refinement of the default behavior be required, these
/// options give you fine grain control over the output.
///
/// ### Specifying Attributes
///
/// All attributes that are output as JSON are configurable.  The default output
/// is a set of all attributes TraceLog outputs, these are:
///
/// - timestamp
/// - level
/// - tag
/// - message
/// - processName
/// - processIdentifier
/// - threadIdentifier
/// - file
/// - function
/// - line
///
/// ### Special formatting options
///
/// JSONFormat has special processing options available for output.
///
/// The options available are:
///
/// - prettyPrint: Add formatting characters to print the output in a more human friendly form.
/// ```
///     /* With `.prettyPrint` */
///     {
///        "timestamp" : 28800.0,
///        "level" : "INFO",
///        "tag" : "TestTag",
///        "message" : "Test message.",
///        "processName" : "TestProcess",
///        "processIdentifier" : 120,
///        "threadIdentifier" : 200,
///        "file" : "JSONFormatTests.swift",
///        "function" : "testAttributeDefaultList()",
///        "line" : 240
///     }
///
///     /* Without `.prettyPrint` */
///
///     {"timestamp":28800.0,"level":"INFO","tag":"TestTag","message":"Test message.",,"processName":"TestProcess","processIdentifier":120,"threadIdentifier":200,"file":"JSONFormatTests.swift","function":"testAttributeDefaultList()","line":240}
/// ```
/// ### Line terminator
///
/// Each log entry formatted by the formatter can be terminated with a character sequence.
/// The default value is a newline (",\n") and can be changed by passing the `terminator`
/// parameter at construction.
///
/// For instance.
///
///     let formatter = JSONFormat(terminator: "\r\n")
///
/// In this case we changed the terminator from the default of ",\n" to "\r\n".  The characters
/// can be any characters that make sense for your application.
///
public struct JSONFormat: OutputStreamFormatter {

    // MARK: Initialization

    /// The designated initializer for this type.
    ///
    /// - Parameters:
    ///     - attributes: A set of `JSONFormat.Attribute`s the will be formatted for output.
    ///     - options: A Set of `JSONFormat.Option`s to allow optional formatting control.
    ///     - terminator: A string that will be output at the end of the output to terminate the entry.
    ///
    public init(attributes: Set<Attribute> = Default.attributes, options: Set<Option> = Default.options, terminator: String = Default.terminator) {
        self.attributes  = Array(attributes)
        self.terminator  = terminator
        self.conditional = options.contains(.prettyPrint) ? ("\n", " ", "\t") : ("", "", "")
    }

    // MARK: `OutputStreamFormatter` Conformance

    /// The encoding that will be used to encode the output output of `bytes(from:)`.
    ///
    /// Value:
    /// ```
    ///    String.Encoding.utf8
    /// ```
    ///
    /// - Note: JSON text exchanged between systems that are not part of a closed ecosystem MUST be encoded using UTF-8 [RFC3629].
    ///
    public let encoding: String.Encoding = .utf8

    /// Text conversion function required by the `OutputStreamFormatter` protocol.
    ///
    /// - SeeAlso: `OutputStreamFormatter` for more information about this function.
    ///
    public func bytes(from entry: Writer.LogEntry) -> Result<[UInt8], OutputStreamFormatterError> {
        var text = String()

        text.write("{\(conditional.newLine)")
        for index in 0..<attributes.count {

            if index > 0 {
                text.write(",\(conditional.newLine)")
            }
            switch attributes[index] {
                case .timestamp:         self.emit(entry.timestamp,                        forKey: "timestamp", to: &text)
                case .level:             self.emit(entry.level,                            forKey: "level", to: &text)
                case .tag:               self.emit(entry.tag,                              forKey: "tag", to: &text)
                case .message:           self.emit(entry.message,                          forKey: "message", to: &text)
                case .processName:       self.emit(entry.runtimeContext.processName,       forKey: "processName", to: &text)
                case .processIdentifier: self.emit(entry.runtimeContext.processIdentifier, forKey: "processIdentifier", to: &text)
                case .threadIdentifier:  self.emit(entry.runtimeContext.threadIdentifier,  forKey: "threadIdentifier", to: &text)
                case .file:              self.emit(entry.staticContext.file,               forKey: "file", to: &text)
                case .function:          self.emit(entry.staticContext.function,           forKey: "function", to: &text)
                case .line:              self.emit(entry.staticContext.line,               forKey: "line", to: &text)
            }
        }
        text.write("\(conditional.newLine)}")
        text.write(self.terminator)

        ///
        /// Since we want to make sure messages are printed, we allow
        /// lossy conversion so that even if an invalid encoding can
        /// still be printed minus the un-encodable characters.
        ///
        guard let data = text.data(using: self.encoding, allowLossyConversion: true)
            else { return .failure(.encodingFailure("Failed to encode entry using \(self.encoding) encoding.")) }

        return .success(Array(data))
    }

    // MARK: Internal & Private methods and structures

    /// Generic type emitter
    private func emit<T, Target>(_ value: T, forKey key: String, to target: inout Target) where Target : TextOutputStream {
        target.write("\(conditional.tab)\"\(key)\"\(conditional.space)")
        target.write(":\(conditional.space)")
        target.write("\(value)")
    }
    /// String emitter
    private func emit<Target>(_ value: String, forKey key: String, to target: inout Target) where Target : TextOutputStream {
        target.write("\(conditional.tab)\"\(key)\"\(conditional.space)")
        target.write(":\(conditional.space)")
        target.write("\"\(value.escaping(charactersIn: CharacterSet.jsonEscapeCharacterSet))\"")
    }
    /// LogLevel emitter
    private func emit<Target>(_ value: LogLevel, forKey key: String, to target: inout Target) where Target : TextOutputStream {
        target.write("\(conditional.tab)\"\(key)\"\(conditional.space)")
        target.write(":\(conditional.space)")
        target.write("\"\(String(describing: value).uppercased())\"")
    }

    /// The attributes to output in the JSON.
    ///
    private let attributes: [Attribute]

    /// The log entry terminator to use for each call to bytes.
    ///
    private let terminator: String

    /// Conditional formatting characters.
    ///
    /// Note: These will be an empty string unless formatting
    ///       is required (option .prettyPrint).
    ///
    private let conditional: (newLine: String, space: String, tab: String)
}

extension JSONFormat {

    // MARK: Default Values

    /// Default values used for `JSONFormat`
    ///
    public enum Default {

        /// Default attributes to output in the JSON.
        ///
        /// Default:
        ///
        ///     Set(JSONFormat.Attribute.allCases)
        ///
        public static let attributes: Set<Attribute> = Set(Attribute.allCases)

        /// A set of options to apply to the output.
        ///
        /// Default:
        ///
        ///     An empty set.
        ///
        /// - SeeAlso: JSONFormat.Option
        ///
        public static let options: Set<Option> = []

        /// The terminator to use at the end of each entry.
        ///
        /// Default:
        ///
        ///     ",\n"
        ///
        public static let terminator: String = ",\n"
    }

    // MARK: Supporting Types

    /// `JSONFormat` attributes that can be output.
    ///
    /// - SeeAlso: `JSONFormat` for usage.
    ///
    public enum Attribute: Int, CaseIterable {
        /// Output the timestamp as an `Int`.
        case timestamp
        /// Output the level as a `String` such as ERROR, WARNING, INFO, etc.
        case level
        /// Output the tag field as a `String`.
        case tag
        /// Output the message field as a `String`.
        case message
        /// Output the processName field as a `String`.
        case processName
        /// Output the processIdentifier field as a `Int`.
        case processIdentifier
        /// Output the threadIdentifier field as a `UInt64`.
        case threadIdentifier
        /// Output the file field as a `String`.
        case file
        /// Output the function field as a `String`.
        case function
        /// Output the line field as a `Int`.
        case line
    }

    /// Available options for formatting the message in json.
    ///
    /// - SeeAlso: `JSONFormat` for usage.
    ///
    public enum Option: Hashable {
        /// Adds formatting characters to the output string for a more human readable format.
        case prettyPrint
    }
}
