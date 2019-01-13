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
///  Created by Tony Stone on 12/26/18.
///
import Foundation

/// The TextFormat is a configurable implementation of a `OutputStreamFormatter`
/// which allows complete control over the fields and format of the output
/// log entry.
///
/// Since the TextFormat is an instance of `OutputStreamFormatter` it can be
/// used with any `Writer` that accepts the `OutputStreamFormatter` on construction.
///
/// TextFormat has a number of options for configuring it for many use-cases.  All
/// options have a default value assigned to them to make it easy to get started
/// without configuration. Should refinement of the default behavior be required, these
/// options give you fine grain control over the output.
///
/// Output Templates
/// ================
///
/// The primary control of the formatting is through the `template` parameter which
/// defines the output variables and constants for each logged entry.  The `template`
/// parameter is a `Swift.String` that allows any constants plus substitution variables
/// that specify the various fields that TraceLog can output.
///
/// Substitution variables take the form %{variable-name} and are case sensitive.  Each
/// variable can be used within the template String as many times as your use-case requires.
///
/// - Substitution variables:
///     - %{date}
///     - %{timestamp}
///     - %{level}
///     - %{tag}
///     - %{processName}
///     - %{processIdentifier}
///     - %{threadIdentifier}
///     - %{file}
///     - %{function}
///     - %{line}
///     - %{message}
///
/// The default template is a human-readable form meant for debugging purposes
/// and excludes extraneous details such as file, function and line. It is defined
/// as:
///
///     template: "%{date} %{processName}[%{processIdentifier}:%{threadIdentifier}] %{level}: <%{tag}> %{message}"
///
/// Which produces an output similar to this:
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag> Example message.
///
/// You can easily create other output forms such as TAB DELIMITED using this
/// template (and adjusting the number of fields to your requirements).
///
///     template: "\"%{date}\",\"%{processName}\",%{processIdentifier},%{threadIdentifier},\"%{level}\",\"%{tag}\",\"%{message}\""
///
/// Your output would look similar to this given the same input as above:
///
///     "1970-01-01 00:00:00.000","ExampleProcess",50,200,"WARNING","ExampleTag","Example message.”
///
/// Control Characters
/// ============================
///
/// TraceLog allows you to embed formatting control characters (\r\n\t\)  into the message when logging messages. The TextFormat
/// allows you to strip those out or escape them so that the output can be more concise or machine readable if required.
///
/// Logging a statement like this is great for reading on the console but could cause issues with parsing
/// a format that requires analyzing the entries.
///
///     let formatter = TextFormat(options: [.controlCharacters(.strip)])
///
///     TraceLog.configure(writers: [ConsoleWriter(format: formatter)])
///
///     logInfo { "\n\t\tThis is a message with control characters that spans multiple lines \n\t\tand is indented with several tab characters." }
///
/// Using `.controlCharacters(.strip)` will allow you to strip those out before output, giving
/// you the following output in the console or file.
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag> This is a message with control characters that spans multiple lines and is indented with several tab characters.
///
/// Using `.controlCharacters(.escape)` will allow you to escape ("\") the characters for output to
/// writers that may require escaping of control characters.
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag> \\n\\t\\tThis is a message with control characters that spans multiple lines \\n\\t\\tand is indented with several tab characters.
///
/// Without this option the output would look like this.
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag>
///             This is a message with control characters that spans multiple lines
///             and is indented with several tab characters.
///
///
/// > Note: using this option does not affect the `terminator` output, terminators will still be printed normally.
///
/// Character Encoding
/// ==================
///
/// The default character encoding of the output is `.utf8` which should be suitable
/// for most applications and can encode all the unicode characters.
///
/// If required, this encoding can be changed by passing a `String.Encoding` value at init
/// to change the output encoding.
///
/// For instance.
///
///     let format = TextFormat(encoding: .utf16)
///
/// Any one of the encodings defined by `String.Encoding` can be used but if you're logging
/// characters outside the range that the encoding can encode, the formatter will alter or drop
/// (replacing with a placeholder character within the encoding) the character.
///
/// If only logging characters within the Ascii character encoding (characters from 0-127) all
/// encodings accept `.symbol` can be used.
///
/// If logging characters outside the Ascii range (0-127), it's recommended
/// that you use a unicode compatible encoding.  All the following encodings
/// can completely encode Unicode:
///
/// - unicode
/// - utf8
/// - utf16
/// - utf16BigEndian
/// - utf16LittleEndian
/// - utf32
/// - utf32BigEndian
/// - utf32LittleEndian
///
/// - Note: We don't find `.symbol` very useful due to it's limited character range and is not supported on linux.  `.japaneseEUC` is also
///         not supported on Linux.
///
/// Terminators
/// ===========
///
/// Each log entry formatted by the formatter can be terminated with a character sequence.
/// The default value is a newline ("\n") and can be changed by passing the `terminator`
/// parameter at construction.
///
/// For instance.
///
///     let formatter = TextFormat(terminator: "\r\n")
///
/// In this case we changed the terminator from the default of "\n" to "\r\n".  The characters
/// can be any characters that make sense for your application. Keep in mind that for console or
/// file type output, a newline "\n" is required in order to write multiple lines to the screen
/// or file.
///
/// - SeeAlso: OutputStreamFormatter
/// - SeeAlso: JSONFormat
/// - SeeAlso: ConsoleWriter
/// - SeeAlso: FileWriter
///
public struct TextFormat: OutputStreamFormatter {

    /// Default values used for TextFormat
    ///
    public struct Default {

        /// Default template to use to output message in.
        ///
        public static let template: String = "%{date} %{processName}[%{processIdentifier}:%{threadIdentifier}] %{level}: <%{tag}> %{message}"

        /// Default DateFormatter for this writer if one is not supplied.
        ///
        /// - Note: Format is "yyyy-MM-dd HH:mm:ss.SSS"
        ///
        /// - Example: "2016-04-23 10:34:26.849"
        ///
        public static let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            formatter.timeZone = TimeZone.current

            return formatter
        }()

        /// A set of options to apply to the output.
        ///
        /// - SeeAlso: TextFormat.Option
        ///
        public static let options: Set<Option> = []

        ///
        /// Encoding of the output of the formatter.
        ///
        public static let encoding: String.Encoding = .utf8

        /// The terminator to use at the end of each entry.
        ///
        public static let terminator: String = "\n"
    }

    /// Special options available to control the
    /// output.
    ///
    public enum Option: Hashable {

        /// Modify the any control characters found in the entry.
        ///
        case controlCharacters(Action)

        public enum Action {

            /// Strip the characters from the message.
            ///
            case strip

            /// Backslash escape the characters.
            ///
            case escape
        }
    }

    /// The designated initializer for this type.
    ///
    /// - parameters:
    ///     - template: The template to use to format the log entry.
    ///     - dateFormatter: An instance of a DateFormatter to convert timestamps to dates.
    ///     - options: A Set of `Options` to allow optional formatting control (see `Option` for list).
    ///     - encoding: The Character encoding to use for the formatted entry.
    ///     - terminator: A string that will be output at the end of the output to terminate the entry.
    ///
    public init(template: String = Default.template, dateFormatter: DateFormatter = Default.dateFormatter, options: Set<Option> = Default.options, encoding: String.Encoding = Default.encoding, terminator: String = Default.terminator) {
        self.dateFormatter = dateFormatter
        self.encoding      = encoding
        self.terminator    = terminator

        self.controlCharacterAction = options.reduce(nil, { (current, option) -> Option.Action? in
            guard case let .controlCharacters(action) = option
                else { return nil }
            return action
        })

        var elements: [TemplateElement] = []

        /// Locate all the ranges for the substitution variables
        /// in the users template.
        ///
        let variables = template.ranges(of: "%\\{(\(Variable.allCases.map({ $0.rawValue }).joined(separator: "|")))\\}", options: [.regularExpression])

        var currentIndex = template.startIndex

        for range in variables {
            /// grab the interspersed constants
            if currentIndex < range.lowerBound {
                elements.append(.constant(String(template[currentIndex..<range.lowerBound])))
            }
            /// record the variable if it's a valid enum value.
            if let variable = Variable(rawValue: template[range].trimmingCharacters(in: CharacterSet(charactersIn: "%{}"))) {
                elements.append(.variable(variable))
            }
            currentIndex = range.upperBound
        }
        /// If there are more characters left after the last variable or
        /// the template is one large constant capture it.
        ///
        if template.endIndex > currentIndex {
            elements.append(.constant(String(template[currentIndex..<template.endIndex])))
        }
        self.template = elements
    }

    /// Text conversion function required by the `OutputStreamFormatter` protocol.
    ///
    public func bytes(from entry: Writer.LogEntry) -> [UInt8]? {
        var text = String()

        /// Write all the elements that have been pre-calculated
        /// out to the TextOutputStream.
        ///
        for element in self.template {
            switch element {

            /// Write the constants directly.
            case .constant(let string):
                text.write(string)

            /// Embed the variables within the constants.
            case .variable(let substitution):
                switch substitution {
                case .date:              self.write(Date(timeIntervalSince1970: entry.timestamp), to: &text)
                case .timestamp:         self.write(entry.timestamp, to: &text)
                case .level:             self.write(entry.level, to: &text)
                case .tag:               self.write(entry.tag, to: &text)
                case .message:           self.write(entry.message, to: &text)
                case .processName:       self.write(entry.runtimeContext.processName, to: &text)
                case .processIdentifier: self.write(entry.runtimeContext.processIdentifier, to: &text)
                case .threadIdentifier:  self.write(entry.runtimeContext.threadIdentifier, to: &text)
                case .file:              self.write(entry.staticContext.file, to: &text)
                case .function:          self.write(entry.staticContext.function, to: &text)
                case .line:              self.write(entry.staticContext.line, to: &text)
                }
            }
        }
        text.write(self.terminator)

        /// Since we want to make sure messages are printed, we allow
        /// lossy conversion so that even if an invalid encoding can
        /// still be printed minus the un-encodable characters.
        ///
        guard let data = text.data(using: self.encoding, allowLossyConversion: true)
            else { return nil }

        return Array(data)
    }

    /// Generic type writer
    func write<T, Target>(_ value: T, to target: inout Target) where Target : TextOutputStream {
        target.write(String(describing: value))
    }

    /// Date writer
    func write<Target>(_ value: Date, to target: inout Target) where Target : TextOutputStream {

        /// Chain to the write(String) version just in case the user
        /// supplied a format that contains control characters that
        /// require processing.
        ///
        /// Note: We think this is unlikely but it is possible so it
        /// must be protected against.
        ///
        self.write(self.dateFormatter.string(from: value), to: &target)
    }

    /// String writer
    func write<Target>(_ value: String, to target: inout Target) where Target : TextOutputStream {
        switch controlCharacterAction {
        case .some(.strip):
            target.write(value.stripping(charactersIn: .controlCharacters))
        case .some(.escape):
            target.write(value.escaping(charactersIn: .controlCharacters))
        case .none:
            target.write(value)
        }
    }

    /// LogLevel writer
    func write<Target>(_ value: LogLevel, to target: inout Target) where Target : TextOutputStream {
        target.write(String(describing: value).uppercased())
    }

    /// The variables that are used to specify a substitution.
    ///
    private enum Variable: String, CaseIterable {
        case date, timestamp, level, tag, processName, processIdentifier, threadIdentifier, file, function, line, message
    }

    /// An element that makes up a portion
    /// of the parsed String template.
    ///
    private enum TemplateElement {
        case variable(Variable), constant(String)
    }

    /// The intermediary form of the template
    /// consisting of a collection of TemplateElements
    /// to write in order.
    ///
    private let template: [TemplateElement]

    /// Date formatter to use for timestamp conversion to date.
    ///
    private let dateFormatter: DateFormatter

    ///
    /// Encoding of the messages logged to the log file.
    ///
    private let encoding: String.Encoding

    /// Should we strip control characters from the message.
    ///
    private let controlCharacterAction: Option.Action?

    /// What terminator should be written at the end of the output.
    ///
    private let terminator: String
}
