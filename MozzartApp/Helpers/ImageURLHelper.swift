//
//  Untitled.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import Foundation

enum ImageURLHelper {
    static func rasterURLIfDicebearSVG(_ url: URL?) -> URL? {
        guard let url else { return nil }
        let s = url.absoluteString

        if s.contains("api.dicebear.com") && s.contains("/svg?") {
            let png = s.replacingOccurrences(of: "/svg?", with: "/png?")
            return URL(string: png)
        }

        return url
    }
}
