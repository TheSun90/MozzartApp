//
//  MatchStatus.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import Foundation

enum MatchStatus: Codable, Equatable {
    case preMatch
    case live
    case finished
    /// fallback
    case unknown(String)

    var rawString: String {
        switch self {
        case .preMatch: return "PRE_MATCH"
        case .live: return "LIVE"
        case .finished: return "FINISHED"
        case .unknown(let value): return value
        }
    }

    init(from decoder: Decoder) throws {
        /// single string
        let single = try decoder.singleValueContainer()
        if let string = try? single.decode(String.self) {
            self = MatchStatus.mapMatchStatus(string)
            return
        }

        ///  array of strings
        if let arr = try? single.decode([String].self), let first = arr.first {
            self = MatchStatus.mapMatchStatus(first)
            return
        }

        /// object
        if let objectValue = try? decoder.container(keyedBy: CodingKeys.self) {
            if let value = (try? objectValue.decodeIfPresent(String.self, forKey: .status)) ?? (try? objectValue.decodeIfPresent(String.self, forKey: .value)) {
                self = MatchStatus.mapMatchStatus(value)
                return
            }
            if let arr2 = (try? objectValue.decodeIfPresent([String].self, forKey: .status)) ?? (try? objectValue.decodeIfPresent([String].self, forKey: .value)),
               let first2 = arr2.first {
                self = MatchStatus.mapMatchStatus(first2)
                return
            }
        }
        self = .unknown("UNKNOWN")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawString)
    }

    private enum CodingKeys: String, CodingKey {
        case status
        case value
    }

    private static func mapMatchStatus(_ string: String) -> MatchStatus {
        switch string.uppercased() {
        case "PRE_MATCH": return .preMatch
        case "LIVE": return .live
        case "FINISHED": return .finished
        default: return .unknown(string)
        }
    }
}
