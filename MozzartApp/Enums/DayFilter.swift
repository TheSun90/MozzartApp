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


extension DayFilter {

    func matches(_ date: Date) -> Bool {

        switch self {

        case .all:
            return true

        case .today:
            let calendar = Calendar.current
            return calendar.isDateInToday(date)

        case .tomorrow:
            let calendar = Calendar.current
            return calendar.isDateInTomorrow(date)

        case .weekend:
            /// Only the upcoming weekend (next Saturday & Sunday)
            let calendar = Calendar.current
            let today = Date()
            let matchDay = calendar.startOfDay(for: date)
            let weekdayToday = calendar.component(.weekday, from: today)

            /// Sunday = 1, Saturday = 7
            let daysUntilSaturday: Int
            if weekdayToday <= 7 {
                daysUntilSaturday = (7 - weekdayToday + 7) % 7
            } else {
                daysUntilSaturday = 0
            }

            guard let upcomingSaturday = calendar.date(byAdding: .day,
                                                   value: daysUntilSaturday == 0 ? 7 : daysUntilSaturday,
                                                   to: today) else {
                return false
            }

            guard let upcomingSunday = calendar.date(byAdding: .day,
                                                value: 1,
                                                to: upcomingSaturday) else {
                return false
            }

            return matchDay == upcomingSaturday || matchDay == upcomingSunday

        case .next:
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            guard let afterTomorrow = calendar.date(byAdding: .day, value: 2, to: startOfToday) else { return false }
            return date >= afterTomorrow
        }
    }
}
