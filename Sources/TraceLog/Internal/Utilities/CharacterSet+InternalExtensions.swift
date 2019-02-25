///
///  CharacterSet+JSON.swift
///  TraceLog
///
///  Created by Tony Stone on 12/30/18.
///
///
import Foundation

internal extension CharacterSet {

    /// Characters that must be escaped in a JSON string according to
    /// the JSON spec RFC 8259  JSON December 2017.
    ///
    /// To escape an extended character that is not in the Basic Multilingual
    /// Plane, the character is represented as a 12-character sequence,
    /// encoding the UTF-16 surrogate pair.  So, for example, a string
    /// containing only the G clef character (U+1D11E) may be represented as
    /// "\uD834\uDD1E".
    ///
    ///     string = quotation-mark *char quotation-mark
    ///
    ///     char = unescaped /
    ///           escape (
    ///               %x22 /          ; "    quotation mark  U+0022
    ///               %x5C /          ; \    reverse solidus U+005C
    ///               %x2F /          ; /    solidus         U+002F
    ///               %x62 /          ; b    backspace       U+0008
    ///               %x66 /          ; f    form feed       U+000C
    ///               %x6E /          ; n    line feed       U+000A
    ///               %x72 /          ; r    carriage return U+000D
    ///               %x74 /          ; t    tab             U+0009
    ///               %x75 4HEXDIG )  ; uXXXX                U+XXXX
    ///
    static let jsonEscapeCharacterSet: CharacterSet = [
        Unicode.Scalar(34), // double quote (")
        Unicode.Scalar(92), // reverse solidus (\)
        Unicode.Scalar(47), // solidus (/)
        Unicode.Scalar(8),  // backspace (\b)
        Unicode.Scalar(12), // form feed (\f)
        Unicode.Scalar(10), // newline (\n)
        Unicode.Scalar(13), // carriage return (\r)
        Unicode.Scalar(9)   // tab (\t)
    ]
}

