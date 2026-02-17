//
//  Extension+String.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

extension String {

    var initials: String {
        let comps = self.split(separator: " ").prefix(2)
        let chars = comps.compactMap { $0.first }
        return String(chars)
    }
}
