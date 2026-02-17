//
//  LoadState.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


enum LoadState: Equatable {
    case loading // Network request in progress
    case loaded // Data loaded
    case failed(String)  // Loading failed with error message
}
