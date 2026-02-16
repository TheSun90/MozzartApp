//
//  LoadState.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


// MARK: - Loading State
/// Describes the state of a remote fetch
/// /// Used by ViewModel to drive UI state (loading, success, error)

enum LoadState: Equatable {
    case notStarted // Initial state – loading has not started yet
    case loading // Network request in progress
    case loaded // Data loaded
    case failed(String)  // Loading failed with error message
}