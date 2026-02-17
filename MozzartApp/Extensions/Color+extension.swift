//
//  Color+extension.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import SwiftUI

// TODO: fix colors with similar to UI
 extension Color {
    static let selectedYellow = Color(hex: 0xF2C400)
     static let backgroundCard = Color.black.opacity(0.45)
    static let teal = Color(hex: 0x30D5C8)

    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
