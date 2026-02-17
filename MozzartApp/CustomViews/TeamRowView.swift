//
//  TeamRowView.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

 struct TeamRowView: View {
    let name: String
    let avatarURL: URL?

    var body: some View {
        HStack(spacing: 10) {
            PlaceholderImageCircle(url: avatarURL, fallbackText: initials(from: name))
                .frame(width: 28, height: 28)

            Text(name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.92))
                .lineLimit(1)
        }
    }

    private func initials(from name: String) -> String {
        let comps = name.split(separator: " ").prefix(2)
        let chars = comps.compactMap { $0.first }
        return String(chars)
    }
}
