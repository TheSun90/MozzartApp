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
    let leagueIconURL: URL?

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            teamColumn(name: awayName, avatarURL: awayAvatar)
                .frame(maxWidth: .infinity)
            VStack(spacing: 4) {
                leagueIconView

                Text(leagueText)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(subtitle)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.75))

                Text(timeText)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.white)
            }
            .frame(maxWidth: .infinity)
            teamColumn(name: homeName, avatarURL: homeAvatar)
                .frame(maxWidth: .infinity)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.backgroundPrimaryColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Team Column

    @ViewBuilder
    private func teamColumn(name: String, avatarURL: URL?) -> some View {
        VStack(spacing: 8) {
            avatarView(name: name, url: avatarURL)
                .frame(width: 34, height: 34)

            Text(name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.90))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }

    // MARK: - League Icon

    @ViewBuilder
    private var leagueIconView: some View {
        if let rasterURL = ImageURLHelper.rasterURLIfDicebearSVG(leagueIconURL) {
            CachedURLImage(url: rasterURL) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 22, height: 22)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
            .frame(width: 22, height: 22)
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        } else {
            Image(systemName: "flag.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 22, height: 22)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
    }

    // MARK: - Avatar

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
