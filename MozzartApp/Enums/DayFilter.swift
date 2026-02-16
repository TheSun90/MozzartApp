//
//  DayFilter.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


import SwiftUI

enum DayFilter: String, CaseIterable, Identifiable {
    case today
    case tomorrow
    case weekend
    case next
    /// case all for debuging purposses - all dates from api are in the past
    case all

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: return "Danas"
        case .tomorrow: return "Sutra"
        case .weekend: return "Vikend"
        case .next: return "Sledece"
        case .all: return "Sve"
        }
    }
}
