//
//  PrematchCard.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

 struct PrematchCard: View {

    let homeName: String
    let awayName: String
    let homeAvatar: URL?
    let awayAvatar: URL?
    let subtitle: String
    let timeText: String
    let leagueText: String

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(homeName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.90))
                    avatarView(name: homeName, url: homeAvatar)
                        .frame(width: 34, height: 34)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 2) {
                    Text(leagueText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.55))

                    Text(subtitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.75))

                    Text(timeText)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .trailing, spacing: 6) {
                    Text(awayName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.90))
                    avatarView(name: awayName, url: awayAvatar)
                        .frame(width: 34, height: 34)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func avatarView(name: String, url: URL?) -> some View {
        ZStack {
            InitialsCircle(name: name, size: 34)

            if let rasterURL = ImageURLHelper.rasterURLIfDicebearSVG(url) {
                CachedURLImage(url: rasterURL) {
                    Color.clear
                }
                .frame(width: 34, height: 34)
                .clipShape(Circle())
            }
        }
    }
}
