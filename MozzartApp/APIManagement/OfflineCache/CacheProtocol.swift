//
//  CacheProtocol.swift
//  MozzartApp
//
//  Created by suncica on 16. 2. 2026..
//

protocol CacheProtocol {
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T?
    func save<T: Encodable>(_ value: T, forKey key: String)
    func remove(forKey key: String)
}
