//
//  APIMatch.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


// MARK: - Match

import Foundation

struct Match: Codable, Identifiable {
    let id: Int
    let homeTeam: String
    let awayTeam: String
    let homeTeamAvatar: String
    let awayTeamAvatar: String
    let date: String
    let status: MatchStatus
    let currentTimeRaw: String?
    let result: MatchResult?
    let sportId: Int
    let competitionId: Int
    
    enum CodingKeys: String, CodingKey {
        case id,
             homeTeam,
             awayTeam,
             homeTeamAvatar,
             awayTeamAvatar,
             date,
             status,
             currentTime,
             result,
             sportId,
             competitionId
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        homeTeam = try container.decode(String.self, forKey: .homeTeam)
        awayTeam = try container.decode(String.self, forKey: .awayTeam)
        homeTeamAvatar = try container.decode(String.self, forKey: .homeTeamAvatar)
        awayTeamAvatar = try container.decode(String.self, forKey: .awayTeamAvatar)
        date = try container.decode(String.self, forKey: .date)
        status = try container.decode(MatchStatus.self, forKey: .status)
        result = try container.decode(MatchResult.self, forKey: .result)
        sportId = try container.decode(Int.self, forKey: .sportId)
        competitionId = try container.decode(Int.self, forKey: .competitionId)
        
        // currentTime can be null/Int/ String
        if let str = try? container.decodeIfPresent(String.self, forKey: .currentTime) {
            currentTimeRaw = str
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .currentTime) {
            currentTimeRaw = String(intValue)
        } else {
            currentTimeRaw = nil
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(homeTeam, forKey: .homeTeam)
        try container.encode(awayTeam, forKey: .awayTeam)
        try container.encode(homeTeamAvatar, forKey: .homeTeamAvatar)
        try container.encode(awayTeamAvatar, forKey: .awayTeamAvatar)
        try container.encode(date, forKey: .date)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(currentTimeRaw, forKey: .currentTime)
        try container.encodeIfPresent(result, forKey: .result)
        try container.encode(sportId, forKey: .sportId)
        try container.encode(competitionId, forKey: .competitionId)
    }

    
}
