//
//  EmptyStateView.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import SwiftUI

// MARK: - Empty rows

 struct EmptyStateView: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.65))

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}
