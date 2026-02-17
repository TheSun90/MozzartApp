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
                        if homeViewModel.filteredLiveMatches.isEmpty {
                            EmptyStateView(text: "Trenutno nema mečeva uživo")
                        } else {
                            ForEach(homeViewModel.filteredLiveMatches) { match in
                                LiveMatchCard(
                                    leagueText: homeViewModel.leagueText(for: match),
                                    timeText: homeViewModel.liveTimeText(for: match),
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
                                    subtitle: homeViewModel.prematchSubtitle,
                                    timeText: homeViewModel.prematchTimeText(for: match),
                                    leagueText: homeViewModel.leagueText(for: match)
                                )
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .refreshable {
                await homeViewModel.load()
            }
        }
        .task {
            await homeViewModel.load()
        }
    }
}
    
