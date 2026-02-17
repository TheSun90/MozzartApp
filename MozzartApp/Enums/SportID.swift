//
//  SportID.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//



enum SportID: Int {
    case football = 1
    case basketball = 2
    case tennis = 5
    case volleyball = 6
    case handball = 8

    var displayName: String {
        switch self {
        case .football: return "Fudbal"
        case .basketball: return "Košarka"
        case .tennis: return "Tenis"
        case .volleyball: return "Odbojka"
        case .handball: return "Rukomet"
        }
    }

    var iconSystemName: String {
        switch self {
        case .football: return "soccerball"
        case .basketball: return "basketball"
        case .tennis: return "tennis.racket"
        case .volleyball: return "volleyball"
        case .handball: return "figure.handball"
        }
    }
}
