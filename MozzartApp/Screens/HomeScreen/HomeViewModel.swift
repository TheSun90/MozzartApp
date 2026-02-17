//
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
    
    @Published var matchesState: LoadState = .notStarted
    @Published var competitionsState: LoadState = .notStarted
    @Published var sportsState: LoadState = .notStarted
    
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
    
    
    func load() {
        Task { await refreshMatches() }
        Task { await refreshCompetitions() }
        Task { await refreshSports() }
    }

    private func refreshMatches() async {
        matchesState = .loading
        do {
            let value = try await homeRepository.refreshMatches()
            matches = value
            matchesState = .loaded
        } catch {
            matchesState = .failed(error.localizedDescription)
        }
    }

    private func refreshCompetitions() async {
        competitionsState = .loading
        do {
            let value = try await homeRepository.refreshCompetitions()
            competitions = value
            competitionsState = .loaded
        } catch {
            competitionsState = .failed(error.localizedDescription)
        }
    }

    private func refreshSports() async {
        sportsState = .loading
        do {
            let value = try await homeRepository.refreshSports()
            sports = value
            sportsState = .loaded
        } catch {
            sportsState = .failed(error.localizedDescription)
        }
    }
    
}
