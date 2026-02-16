//
//  APIClient.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import Foundation

protocol APIClientType {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct APIClient: APIClientType {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(T.self, from: data)
    }
}
