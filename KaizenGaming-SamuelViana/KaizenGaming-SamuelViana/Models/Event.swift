//
//  Event.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import Foundation

struct Event: Codable {
    let id: String
    let sportId: String
    let name: String
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case id = "i"
        case sportId = "si"
        case name = "d"
        case timestamp = "tt"
    }

    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp))
    }

    /// Splits "TeamA-TeamB", preserving hyphens within team names.
    var competitors: (first: String, second: String) {
        let parts = name.components(separatedBy: "-")
        guard parts.count >= 2 else { return (formatted(name), "") }
        let first = formatted(parts[0].trimmingCharacters(in: .whitespaces))
        let second = formatted(parts.dropFirst().joined(separator: "-").trimmingCharacters(in: .whitespaces))
        return (first, second)
    }

    /// Adds spaces for camelCase, acronyms, Roman numerals, slashes and parentheses.
    private func formatted(_ text: String) -> String {
        var s = text
        s = s.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
        s = s.replacingOccurrences(of: "([A-Z]+)([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
        s = s.replacingOccurrences(of: "([A-Z])(II|III|IV|V|VI|VII|VIII|IX|X)$", with: "$1 $2", options: .regularExpression)
        s = s.replacingOccurrences(of: "\\s*/\\s*", with: " / ", options: .regularExpression)
        s = s.replacingOccurrences(of: "\\s*\\(", with: " (", options: .regularExpression)
        return s
    }
}
