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

/// The TextFormat is a configurable implementation of a `TextOutputFormatter`
/// which allows complete control over the fields and format of the output
/// log entry.
///
/// Since the TextFormat is an instance of `TextOutputFormatter` it can be
/// used with any `Writer` that accepts the `TextOutputFormatter` on construction.
///
/// TextFormat has a number of options for configuring it for many use-cases.  All
/// options have a default value assigned to them to make it easy to get started
/// without configuration. Should refinement of the default behavior be required, these
/// options give you fine grain control over the output.
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
/// Stripping Control Characters
/// ============================
///
/// TraceLog allows you to embed formatting control characters (\r\n\t\)  into the message when logging messages. The TextFormat
/// allows you to strip those out so that the output can be more concise or machine readable if required.
///
/// Logging a statement like this is great for reading on the console but could cause issues with parsing
/// a format the requires analyzing the entries.
///
///     let formatter = TextFormat(stripControlCharacters: true)
///
///     TraceLog.configure(writers: [ConsoleWriter(format: formatter)])
///
///     logInfo { "\n\t\tThis is a message with control characters that spans multiple lines \n\t\tand is indented with several tab characters." }
///
/// Using `stripControlCharacters: true` will allow you to strip those out before output, giving
/// you the following output in the console or file.
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag> This is a message with control characters that spans multiple lines and is indented with several tab characters.
///
/// With stripControlCharacters: false` the output would look like this.
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag>
///             This is a message with control characters that spans multiple lines
///             and is indented with several tab characters.
///
///
/// > Note: using `stripControlCharacters` does not affect the `terminator` output, it only affects the message portion.  Terminators will still be printed.
///
/// Output Templates
/// ================
///
/// The primary control of the formatting is through the `template` parameter which
/// defines the output variables and constants for each logged entry.  The `template`
/// parameter is a `Swift.String` that allows any constants plus substitution variables
/// that specify the various fields that TraceLog can output.
///
/// Substitution variables take the form %{variable-name} and are case sensitive.  If
/// it makes sense for your use-case, you can also use each variable as many times as
/// required within the template String.
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
/// The default template is human-readable simple form meant for debugging purposes
/// and excludes extraneous details such as file, function and line. It is defined
/// as:
///
///     template: "%{date} %{processName}[%{processIdentifier}:%{threadIdentifier}] %{level}: <%{tag}> %{message}"
///
///
/// Which produces an output similar to this:
///
///     1970-01-01 00:00:00.000 ExampleProcess[100:1100] INFO: <ExampleTag> Example message.
///
/// You can easily create other output forms such as TAB DELIMITED using this
/// template (and adjusting the number of fields to your requirements). Also add
/// a terminator to the output using `terminator: "\n"` at init.
///
///     template: "\"%{date}\",\"%{processName}\",%{processIdentifier},%{threadIdentifier},\"%{level}\",\"%{tag}\",\"%{message}\""
///     terminator: "\n"
///
/// Your output would look similar to this given the same input as above:
///
///     "1970-01-01 00:00:00.000","ExampleProcess",50,200,"WARNING","ExampleTag","Example message.”\n
///
/// - SeeAlso: TextOutputFormatter
/// - SeeAlso: JSONFormat
/// - SeeAlso: ConsoleWriter
/// - SeeAlso: FileWriter
///
public struct TextFormat: TextOutputFormatter {

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

        /// Should the formatter strip control characters from the message
        /// portion of the log entry?
        ///
        public static let stripControlCharacters: Bool = false

        /// The terminator to use at the end of each entry.
        ///
        public static let terminator: String = "\n"
    }

    /// The designated initializer for this type.
    ///
    /// - parameters:
    ///     - template: The template to use to format the log entry.
    ///     - dateFormatter: An instance of a DateFormatter to convert timestamps to dates.
    ///     - stripControlCharacters: If true, strip control characters from the message attribute before outputting.
    ///     - terminator: A string that will be output at the end of the output to terminate the entry.
    ///
    public init(template: String = Default.template, dateFormatter: DateFormatter = Default.dateFormatter, stripControlCharacters: Bool = Default.stripControlCharacters, terminator: String = Default.terminator) {
        self.dateFormatter          = dateFormatter
        self.stripControlCharacters = stripControlCharacters
        self.terminator             = terminator

        var elements: [TemplateElement] = []

        /// Locate all the ranges for the substitution variables
        /// in the users template.
        ///
        let variables = template.ranges(of: "%\\{(\(Variable.allCases.map({ $0.rawValue}).joined(separator: "|")))\\}", options: [.regularExpression])

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

    /// Text conversion function required by the `TextOutputFormatter` protocol.
    ///
    public func text(from timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> TextOutputStreamable? {
        var text = ""

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
                case .date:              text.write("\(self.dateFormatter.string(from: Date(timeIntervalSince1970: timestamp)))")
                case .timestamp:         text.write("\(timestamp)")
                case .level:             text.write("\(level)".uppercased())
                case .tag:               text.write(tag)
                case .message:           text.write(self.stripControlCharacters ? message.stripping(characters: "\r|\n|\t") : message)
                case .processName:       text.write(runtimeContext.processName)
                case .processIdentifier: text.write("\(runtimeContext.processIdentifier)")
                case .threadIdentifier:  text.write("\(runtimeContext.threadIdentifier)")
                case .file:              text.write(staticContext.file)
                case .function:          text.write(staticContext.function)
                case .line:              text.write("\(staticContext.line)")
                }
            }
        }
        text.write(self.terminator)

        return text
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

    /// Should we strip control characters from the message.
    ///
    private let stripControlCharacters: Bool

    /// What terminator should be written at the end of the output.
    ///
    private let terminator: String
}

/// Private extension for specific String
/// methods used internally to this file.
///
private extension String {

    func stripping(characters: String) -> String {
        return self.compactMap {
            guard !characters.contains($0)
                else { return nil }
            return String($0)
        }.joined()
    }

    func ranges(of pattern: String, options: CompareOptions = []) -> [Range<String.Index>] {

        var ranges: [Range<String.Index>] = []
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
            let range = self.range(of: pattern, options: options, range: searchStartIndex..<self.endIndex), !range.isEmpty {

                ranges.append(range)
                searchStartIndex = range.upperBound
        }
        return ranges
    }
}
