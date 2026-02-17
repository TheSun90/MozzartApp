//
//  HomeView.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeViewModel = HomeViewModel.makeDefault()
    
    var body: some View {

        ZStack {
            BackgroundColorView()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SportSegmentedRow(
                        sports: homeViewModel.sports,
                        selectedSportId: $homeViewModel.selectedSportId
                    )
                    .padding(.top, 12)

                    SectionHeader(title: "MEČEVI UŽIVO")

                    VStack(spacing: 12) {
                        if filteredLiveMatches.isEmpty {
                            EmptyStateView(text: "Trenutno nema mečeva uživo")
                        } else {
                            ForEach(filteredLiveMatches) { match in
                                LiveMatchCard(
                                    leagueText: leagueText(for: match),
                                    timeText: liveTimeText(for: match),
                                    homeName: match.homeTeam,
                                    awayName: match.awayTeam,
                                    homeAvatar: URL(string: match.homeTeamAvatar),
                                    awayAvatar: URL(string: match.awayTeamAvatar),
                                    homeScore: match.result?.home,
                                    awayScore: match.result?.away
                                )
                            }
                        }
                    }

                    SectionHeader(title: "PREMATCH PONUDA")

                    DaySegmentedControll(selected: $homeViewModel.selectedDayFilter)

                    VStack(spacing: 12) {
                        if homeViewModel.filteredPrematchMatches.isEmpty {
                            EmptyStateView(text: "Nema prematch mečeva za izabrani filter")
                        } else {
                            ForEach(homeViewModel.filteredPrematchMatches) { match in
                                PrematchCard(
                                    homeName: match.homeTeam,
                                    awayName: match.awayTeam,
                                    homeAvatar: URL(string: match.homeTeamAvatar),
                                    awayAvatar: URL(string: match.awayTeamAvatar),
                                    subtitle: prematchSubtitle(for: match),
                                    timeText: prematchTimeText(for: match),
                                    leagueText: leagueText(for: match)
                                )
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .task { homeViewModel.load() }
    }
    
    
    // TODO: refactor

    private var filteredLiveMatches: [Match] {
        homeViewModel.liveMatches.filter { match in
            guard let selected = homeViewModel.selectedSportId else { return true }
            return match.sportId == selected
        }
    }

    private func leagueText(for match: Match) -> String {
        homeViewModel.competitionName(for: match.competitionId)
    }

    private func liveTimeText(for match: Match) -> String {

        // Football = 1
        let isFootball = match.sportId == SportID.football.rawValue

        if isFootball, let minute = match.currentTimeMinute {
            if minute <= 45 { return "1. poluvreme – \(minute)’" }
            if minute <= 90 { return "2. poluvreme – \(minute)’" }
            return "Produžeci – \(minute)’"
        }

        return match.currentTimeDisplay ?? "Uživo"
    }

    private func prematchSubtitle(for match: Match) -> String {
        return homeViewModel.selectedDayFilter.title
    }

    private func prematchTimeText(for match: Match) -> String {
        if let date = DateHelper.fromStringToDate(from: match.date) {
            return DateHelper.timeOnly(from: date)
        }
        if match.date.count >= 5 {
            return String(match.date.suffix(5))
        }
        return match.date
    }
}
    

