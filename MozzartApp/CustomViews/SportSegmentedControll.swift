//
//  SportSegmentedControll.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

struct SportSegmentedControll: View {
    let title: String
    let iconSystemName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            if isSelected {
                HStack(spacing: 10) {
                    //TODO: fetch image from url
                    Image(systemName: iconSystemName)
                        .font(.system(size: 16, weight: .bold))

                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .lineLimit(1)
                }
                .foregroundStyle(Color.black)
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color.selectedYellow)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                Image(systemName: iconSystemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.9))
                    .frame(width: 52, height: 52)
                    .background(Color.white.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sport pills

struct SportSegmentedRow: View {
    let sports: [Sport]
    @Binding var selectedSportId: Int?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if sports.isEmpty {
                    ForEach(SportID.allCases, id: \.rawValue) { sportID in
                        SportSegmentedControll(
                            title: sportID.displayName,
                            iconSystemName: sportID.iconSystemName,
                            isSelected: selectedSportId == sportID.rawValue
                        ) {
                            selectedSportId = sportID.rawValue
                        }
                    }
                } else {
                    ForEach(sports) { sport in
                        if let sportID = SportID(rawValue: sport.id) {
                            SportSegmentedControll(
                                title: sportID.displayName,
                                iconSystemName: sportID.iconSystemName,
                                isSelected: selectedSportId == sport.id
                            ) {
                                selectedSportId = sport.id
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }

}

