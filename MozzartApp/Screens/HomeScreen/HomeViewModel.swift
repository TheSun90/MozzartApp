//  HomeViewModel.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import SwiftUI
import Combine

@MainActor

final class HomeViewModel: ObservableObject {
    
    @Published var matches: [Match] = []
    @Published var competitions: [Competition] = []
    @Published var sports: [Sport] = []
    
    @Published var matchesState: LoadState = .loaded
    @Published var competitionsState: LoadState = .loaded
    @Published var sportsState: LoadState = .loaded
    
    /// properties used for segmented controll
    @Published var selectedSportId: Int? = SportID.football.rawValue
    @Published var selectedDayFilter: DayFilter = .all
    
    
    private let homeRepository: HomeAPIType

    init(homeRepository: HomeAPIType) {
        self.homeRepository = homeRepository
        /// cache load
        self.matches = homeRepository.loadCachedMatches()
        self.competitions = homeRepository.loadCachedCompetitions()
        self.sports = homeRepository.loadCachedSports()
    }

    /// create viewModel with the default repository.
    @MainActor
    static func makeDefault() -> HomeViewModel {
        HomeViewModel(homeRepository: HomeAPI())
    }

    var liveMatches: [Match] {
        matches.filter { $0.status == .live }
    }
    
    func competitionIconURL(for competitionId: Int) -> URL? {
        guard let urlString = competitionsById[competitionId]?.competitionIconUrl else { return nil }
        return URL(string: urlString)
    }

    var prematchMatches: [Match] {
        matches.filter { $0.status == .preMatch }
    }
    
    var competitionsById: [Int: Competition] {
        Dictionary(uniqueKeysWithValues: competitions.map { ($0.id, $0) })
    }

    func competitionName(for competitionId: Int) -> String {
        competitionsById[competitionId]?.name ?? "Competition: \(competitionId)"
    }
    
    
    var sportsById: [Int: Sport] {
        Dictionary(uniqueKeysWithValues: sports.map { ($0.id, $0) })
    }

    func sportName(for sportId: Int) -> String {
        sportsById[sportId]?.name ?? "Sport: \(sportId)"
    }
    
    var filteredPrematchMatches: [Match] {
        prematchMatches
            .filter { match in
                /// Sport filter
                guard let selectedSportId else { return true }
                return match.sportId == selectedSportId
            }
            .filter { match in
                /// Day filter
                guard selectedDayFilter != .all else { return true }

                guard let date = DateHelper.fromStringToDate(from: match.date) else {
                    return true
                }
                return selectedDayFilter.matches(date)
            }
    }
    
    
    // MARK: - Data Loading
    
    func load() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.refreshMatches() }
            group.addTask { await self.refreshCompetitions() }
            group.addTask { await self.refreshSports() }
        }
    }

    private func refreshMatches() async {
        if matches.isEmpty { matchesState = .loading }

        do {
            let value = try await homeRepository.refreshMatches()
            matches = value
            matchesState = .loaded
        } catch {
            matchesState = .failed(error.localizedDescription)
        }
    }

    private func refreshCompetitions() async {
        if competitions.isEmpty {
            competitionsState = .loading
        }

        do {
            let value = try await homeRepository.refreshCompetitions()
            competitions = value
            competitionsState = .loaded
        } catch {
            competitionsState = .failed(error.localizedDescription)
        }
    }

    private func refreshSports() async {
        if sports.isEmpty {
            sportsState = .loading
        }

        do {
            let value = try await homeRepository.refreshSports()
            sports = value
            sportsState = .loaded
        } catch {
            sportsState = .failed(error.localizedDescription)
        }
    }
}

// MARK: extension of HomeViewModel
/// helpers for LiveMatchCard and PrematchCard

extension HomeViewModel {
    
    var filteredLiveMatches: [Match] {
        liveMatches.filter { match in
            guard let selected = selectedSportId else { return true }
            return match.sportId == selected
        }
    }
    
    func leagueText(for match: Match) -> String {
        competitionName(for: match.competitionId)
    }
    
    func liveTimeText(for match: Match) -> String {
        let isFootball = match.sportId == SportID.football.rawValue

        if isFootball, let minute = match.currentTimeMinute {
            if minute <= 45 { return "1. poluvreme – \(minute)’" }
            if minute <= 90 { return "2. poluvreme – \(minute)’" }
            return "Produžeci – \(minute)’"
        }

        return match.currentTimeDisplay ?? "Uživo"
    }
    
    func prematchTimeText(for match: Match) -> String {
        if let date = DateHelper.fromStringToDate(from: match.date) {
            return DateHelper.timeOnly(from: date)
        }

        if match.date.count >= 5 {
            return String(match.date.suffix(5))
        }

        return match.date
    }
    
    var prematchSubtitle: String {
        selectedDayFilter.title
    }
}
