//
//  LiveMatchCard.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

 struct LiveMatchCard: View {

    let leagueText: String
    let timeText: String
    let homeName: String
    let awayName: String
    let homeAvatar: URL?
    let awayAvatar: URL?
    let homeScore: Int?
    let awayScore: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                
                //TODO: import svg library
                /// Placeholder
                Circle()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 18, height: 18)

                Text(leagueText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.60))

                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.teal.opacity(0.20))
                        .frame(width: 14, height: 14)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(Color.teal)
                        )

                    Text(timeText)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.teal)
                }
            }

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 12) {
                    TeamRowView(name: homeName, avatarURL: homeAvatar)
                    TeamRowView(name: awayName, avatarURL: awayAvatar)
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 12) {
                    Text(scoreText(homeScore))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.white)
                    Text(scoreText(awayScore))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.white)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.backgroundCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

     func scoreText(_ value: Int?) -> String {
        guard let value else { return "—" }
        return String(value)
    }
}
