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
    
    @Published private(set) var competitionsById: [Int: Competition] = [:]
    
    @Published var matchesState: LoadState = .loaded
    @Published var competitionsState: LoadState = .loaded
    @Published var sportsState: LoadState = .loaded
    
    /// properties used for segmented controll
    @Published var selectedSportId: Int? = SportID.football.rawValue
    @Published var selectedDayFilter: DayFilter = .all
    
    
    private let homeRepository: HomeAPIType
    private var loadTask: Task<Void, Never>?

    init(homeRepository: HomeAPIType) {
        self.homeRepository = homeRepository
        /// cache load
        self.matches = homeRepository.loadCachedMatches()
        self.competitions = homeRepository.loadCachedCompetitions()
        self.competitionsById = Dictionary(uniqueKeysWithValues: competitions.map { ($0.id, $0) })
        self.sports = homeRepository.loadCachedSports()
    }
    
    deinit {
        loadTask?.cancel()
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

    func competitionName(for competitionId: Int) -> String? {
        competitionsById[competitionId]?.name
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

    /// If called again while a previous load is running, the previous one is cancelled.
    func load() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.loadInternal()
        }
    }

    private func loadInternal() async {
        async let matchesTask: Void = refreshMatches()
        async let competitionsTask: Void = refreshCompetitions()
        async let sportsTask: Void = refreshSports()

        _ = await (matchesTask, competitionsTask, sportsTask)
    }

    private func refreshMatches() async {
        guard !Task.isCancelled else { return }
        if matches.isEmpty { matchesState = .loading }

        do {
            let value = try await homeRepository.refreshMatches()
            guard !Task.isCancelled else { return }
            matches = value
            matchesState = .loaded
        } catch is CancellationError {
            // Ignore cancellation
        } catch {
            matchesState = .failed(error.localizedDescription)
        }
    }

    private func refreshCompetitions() async {
        guard !Task.isCancelled else { return }
        if competitions.isEmpty {
            competitionsState = .loading
        }

        do {
            let value = try await homeRepository.refreshCompetitions()
            guard !Task.isCancelled else { return }
            competitions = value
            competitionsById = Dictionary(uniqueKeysWithValues: value.map { ($0.id, $0) })
            competitionsState = .loaded
        } catch is CancellationError {
            // Ignore cancellation
        } catch {
            competitionsState = .failed(error.localizedDescription)
        }
    }

    private func refreshSports() async {
        guard !Task.isCancelled else { return }
        if sports.isEmpty {
            sportsState = .loading
        }

        do {
            let value = try await homeRepository.refreshSports()
            guard !Task.isCancelled else { return }
            sports = value
            sportsState = .loaded
        } catch is CancellationError {
            // Ignore cancellation
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
        competitionName(for: match.competitionId) ?? "Nepoznata liga"
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
