///
///  TextFormat+InternationalLanguagesTests.swift
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
///  Created by Tony Stone on 12/31/18.
///
import XCTest

import TraceLog

/// TextFormat International Languages Tests
///
/// Sentences that contain all letters commonly used in a language
/// --------------------------------------------------------------
///
/// Markus Kuhn <http://www.cl.cam.ac.uk/~mgk25/> -- 2012-04-11
///
class TextFormatInternationalLanguagesTests: XCTestCase {

    /// Test that we can encode a "Danish (da)" message.
    ///
    func testBytesWithDanishMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Wolther spillede på xylofon.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Wolther spillede på xylofon."

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Danish language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Danish\".")
    }

    /// Test that we can encode a "German (de)" message.
    ///
    func testBytesWithGermanMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Falsches Üben von Xylophonmusik quält jeden größeren Zwerg", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Falsches Üben von Xylophonmusik quält jeden größeren Zwerg"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the German language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"German\".")
    }

    /// Test that we can encode a "Greek (el)" message.
    ///
    func testBytesWithGreekMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Γαζέες καὶ μυρτιὲς δὲν θὰ βρῶ πιὰ στὸ χρυσαφὶ ξέφωτο", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Γαζέες καὶ μυρτιὲς δὲν θὰ βρῶ πιὰ στὸ χρυσαφὶ ξέφωτο"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Greek language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Greek\".")
    }

    /// Test that we can encode a "English (en)" message.
    ///
    func testBytesWithEnglishMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "The quick brown fox jumps over the lazy dog", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "The quick brown fox jumps over the lazy dog"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the English language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"English\".")
    }

    /// Test that we can encode a "Spanish (es)" message.
    ///
    func testBytesWithSpanishMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "El pingüino Wenceslao hizo kilómetros bajo exhaustiva lluvia y frío, añoraba a su querido cachorro.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "El pingüino Wenceslao hizo kilómetros bajo exhaustiva lluvia y frío, añoraba a su querido cachorro."

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Spanish language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Spanish\".")
    }

    /// Test that we can encode a "French (fr)" message.
    ///
    func testBytesWithFrenchMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Portez ce vieux whisky au juge blond qui fume sur son île intérieure, à côté de l'alcôve ovoïde, où les bûches se consument dans l'âtre, ce qui lui permet de penser à la cænogenèse de l'être dont il est question dans la cause ambiguë entendue à Moÿ, dans un capharnaüm qui, pense-t-il, diminue çà et là la qualité de son œuvre.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Portez ce vieux whisky au juge blond qui fume sur son île intérieure, à côté de l'alcôve ovoïde, où les bûches se consument dans l'âtre, ce qui lui permet de penser à la cænogenèse de l'être dont il est question dans la cause ambiguë entendue à Moÿ, dans un capharnaüm qui, pense-t-il, diminue çà et là la qualité de son œuvre."

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the French language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"French\".")
    }

    /// Test that we can encode a "IrishGaelic (ga)" message.
    ///
    func testBytesWithIrishGaelicMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "D'fhuascail Íosa, Úrmhac na hÓighe Beannaithe, pór Éava agus Ádhaimh", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "D'fhuascail Íosa, Úrmhac na hÓighe Beannaithe, pór Éava agus Ádhaimh"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the IrishGaelic language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"IrishGaelic\".")
    }

    /// Test that we can encode a "Hungarian (hu)" message.
    ///
    func testBytesWithHungarianMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Árvíztűrő tükörfúrógép", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Árvíztűrő tükörfúrógép"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Hungarian language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Hungarian\".")
    }

    /// Test that we can encode a "Icelandic (is)" message.
    ///
    func testBytesWithIcelandicMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Kæmi ný öxi hér ykist þjófum nú bæði víl og ádrepa", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Kæmi ný öxi hér ykist þjófum nú bæði víl og ádrepa"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Icelandic language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Icelandic\".")
    }

    /// Test that we can encode a "Japanese (jp, )" message.
    ///
    func testBytesWithJapaneseMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Japanese language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Japanese\".")
    }

    /// Test that we can encode a "Katakana ()" message.
    ///
    func testBytesWithKatakanaMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "イロハニホヘト チリヌルヲ ワカヨタレソ ツネナラム ウヰノオクヤマ ケフコエテ アサキユメミシ ヱヒモセスン", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "イロハニホヘト チリヌルヲ ワカヨタレソ ツネナラム ウヰノオクヤマ ケフコエテ アサキユメミシ ヱヒモセスン"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Katakana language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Katakana\".")
    }

    /// Test that we can encode a "Polish (pl)" message.
    ///
    func testBytesWithPolishMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Pchnąć w tę łódź jeża lub ośm skrzyń fig", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Pchnąć w tę łódź jeża lub ośm skrzyń fig"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Polish language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Polish\".")
    }

    /// Test that we can encode a "Russian (ru)" message.
    ///
    func testBytesWithRussianMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "чащах юга жил бы цитрус? Да, но фальшивый экземпляр!", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "чащах юга жил бы цитрус? Да, но фальшивый экземпляр!"

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Russian language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Russian\".")
    }

    /// Test that we can encode a "Turkish (tr)" message.
    ///
    func testBytesWithTurkishMessage() {
        let input: Writer.LogEntry = (timestamp: 28800.0, level: .info, tag: "TestTag", message: "Pijamalı hasta, yağız şoföre çabucak güvendi.", runtimeContext: TestRuntimeContext(processName: "TestProcess", processIdentifier: 100, threadIdentifier: 1100), staticContext: TestStaticContext())
        let expected: String       = "Pijamalı hasta, yağız şoföre çabucak güvendi."

        let format = TextFormat(template: "%{message}", encoding: .utf8, terminator: "")

        guard case .success(let bytes) = format.bytes(from: input)
            else { XCTFail("Failed to convert log entry for the Turkish language."); return }

        XCTAssertEqual(String(bytes: bytes, encoding: .utf8), expected, "Failed conversion for \"Turkish\".")
    }
}
