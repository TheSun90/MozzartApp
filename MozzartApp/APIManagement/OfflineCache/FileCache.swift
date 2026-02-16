//
//  FileCache.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

import Foundation

final class FileCache: CacheProtocol {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let directoryURL: URL
    
    init(folderName: String = "MozzartFile") {
        /// offline suport by File Manager
        let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        directoryURL = baseURL.appendingPathComponent(folderName, isDirectory: true)
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }
    
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        let url = fileURL(for: key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, forKey key: String) {
        let url = fileURL(for: key)
        guard let data = try? encoder.encode(value) else { return }
        try? data.write(to: url, options: [.atomic])
    }

    func remove(forKey key: String) {
        let url = fileURL(for: key)
        try? FileManager.default.removeItem(at: url)
    }

    private func fileURL(for key: String) -> URL {
        directoryURL.appendingPathComponent("\(key).json")
    }
}
