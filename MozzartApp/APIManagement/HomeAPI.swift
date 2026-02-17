//
//  HomeAPI.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import Foundation

protocol HomeAPIType {

    /// Cache
    func loadCachedMatches() -> [Match]
    func loadCachedCompetitions() -> [Competition]
    func loadCachedSports() -> [Sport]

    /// Network refresh
    func refreshMatches() async throws -> [Match]
    func refreshCompetitions() async throws -> [Competition]
    func refreshSports() async throws -> [Sport]
}

final class HomeAPI: HomeAPIType {
    
    private let api: APIClientType
    private let cache: CacheProtocol
    

    init(api: APIClientType = APIClient(),
         cache: CacheProtocol = FileCache()) {
        self.api = api
        self.cache = cache
    }
    
    
    // MARK: Cache load

    func loadCachedMatches() -> [Match] {
        cache.load([Match].self, forKey: Key.matches) ?? []
    }

    func loadCachedCompetitions() -> [Competition] {
        cache.load([Competition].self, forKey: Key.competitions) ?? []
    }

    func loadCachedSports() -> [Sport] {
        cache.load([Sport].self, forKey: Key.sports) ?? []
    }

    // MARK: - Refresh from network

    func refreshMatches() async throws -> [Match] {
        do {
            let value: [Match] = try await api.fetch(.matches)
            cache.save(value, forKey: Key.matches)
            return value
        } catch {
            return loadCachedMatches()
        }
    }

    func refreshCompetitions() async throws -> [Competition] {
        do {
            let value: [Competition] = try await api.fetch(.competitions)
            cache.save(value, forKey: Key.competitions)
            return value
        } catch {
            return loadCachedCompetitions()
        }
    }

    func refreshSports() async throws -> [Sport] {
        do {
            let value: [Sport] = try await api.fetch(.sports)
            cache.save(value, forKey: Key.sports)
            return value
        } catch {
            return loadCachedSports()
        }
    }
}
