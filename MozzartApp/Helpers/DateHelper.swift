//
//  DateHelper.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


import SwiftUI

struct DateHelper {
    
    static let fullDateFormatter: DateFormatter = {
       let df = DateFormatter()
       df.locale = Locale(identifier: "en_US_POSIX")
       df.timeZone = .current
       df.dateFormat = "yyyy-MM-dd HH:mm"
       return df
   }()

    static func fromStringToDate(from string: String) -> Date? {
        fullDateFormatter.date(from: string)
   }
    
    static let timeOnlyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = .current
        df.dateFormat = "HH:mm"
        return df
    }()

    static func timeOnly(from date: Date) -> String {
        timeOnlyFormatter.string(from: date)
    }
}
