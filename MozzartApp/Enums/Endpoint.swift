//
//  Endpoint.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//


import Foundation

enum Endpoint: String {
    case matches = "matches"
    case competitions = "competitions"
    case sports = "sports"

    var url: URL {
        URL(string: "https://take-home-api-7m87.onrender.com/api/\(rawValue)")!
    }
}