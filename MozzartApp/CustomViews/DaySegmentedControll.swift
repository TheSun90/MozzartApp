//
//  DaySegmentedControll.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//


import SwiftUI

struct DaySegmentedControll: View {

    @Binding var selected: DayFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(DayFilter.allCases) { item in
                    DayRow(
                        title: item.title,
                        isSelected: selected == item
                    ) {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selected = item
                        }
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
}

private struct DayRow: View {

    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isSelected ? Color.black : Color.white.opacity(0.70))
                .padding(.horizontal, 26)
                .frame(height: 50)
                .background(isSelected ? Color.selectedYellow : Color.white.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
