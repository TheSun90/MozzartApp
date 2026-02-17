//
//  APICompetition.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


// MARK: - Competition

struct Competition: Codable, Identifiable {
    let id: Int
    let sportId: Int
    let name: String
    let competitionIconUrl: String
}
