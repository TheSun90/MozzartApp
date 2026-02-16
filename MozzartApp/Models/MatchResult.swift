//
//  MatchResult.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//
import Foundation

struct MatchResult: Codable {
    let home: Int?
    let away: Int?

    enum CodingKeys: String, CodingKey {
        case home, away
        case homeScore, awayScore
        case homeTeam, awayTeam
    }

    init(home: Int?, away: Int?) {
        self.home = home
        self.away = away
    }

    init(from decoder: Decoder) throws {
        /// object/key
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            let home = (try? container.decodeIfPresent(Int.self, forKey: .home))
                ?? (try? container.decodeIfPresent(Int.self, forKey: .homeScore))
                ?? (try? container.decodeIfPresent(Int.self, forKey: .homeTeam))

            let away = (try? container.decodeIfPresent(Int.self, forKey: .away))
                ?? (try? container.decodeIfPresent(Int.self, forKey: .awayScore))
                ?? (try? container.decodeIfPresent(Int.self, forKey: .awayTeam))

            self.home = home
            self.away = away
            return
        }

        /// string
        let single = try decoder.singleValueContainer()
        if let string = try? single.decode(String.self) {
            let cleanedString = string.replacingOccurrences(of: " ", with: "")
            let parts = cleanedString.split(whereSeparator: { $0 == ":" || $0 == "-" })
            if parts.count == 2 {
                self.home = Int(parts[0])
                self.away = Int(parts[1])
            } else {
                self.home = nil
                self.away = nil
            }
            return
        }

        self.home = nil
        self.away = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(home, forKey: .home)
        try container.encodeIfPresent(away, forKey: .away)
    }
}
