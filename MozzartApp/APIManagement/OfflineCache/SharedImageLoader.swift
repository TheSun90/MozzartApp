//
//  SharedImageLoader.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

// MARK: - Shared image loader (dedupe + throttle + 429 logic)
 actor SharedImageLoader {

    static let shared = SharedImageLoader(maxConcurrent: 1)

    private let maxConcurrent: Int
    private var activeCount: Int = 0

    private var inFlight: [URL: Task<Data?, Never>] = [:]

    init(maxConcurrent: Int) {
        self.maxConcurrent = maxConcurrent
    }

    func data(for url: URL) async -> Data? {
        // Deduplicate: if the same URL is already loading, await it
        if let task = inFlight[url] {
            return await task.value
        }

        let task = Task<Data?, Never> {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
            if let cached = URLCache.shared.cachedResponse(for: request) {
                let mime = (cached.response as? HTTPURLResponse)?.mimeType ?? (cached.response.mimeType)
                let isImageMime = (mime ?? "").lowercased().hasPrefix("image/")

                if isImageMime, UIImage(data: cached.data) != nil {
                    return cached.data
                } else {
                    URLCache.shared.removeCachedResponse(for: request)
                }
            }

            // Throttle concurrency
            await acquireSlot()
            defer { Task { await releaseSlot() } }

            // Network with 429 backoff
            var delaySeconds: UInt64 = 1
            for attempt in 0..<3 {
                do {
                    let (data, response) = try await URLSession.shared.data(for: request)

                    if let http = response as? HTTPURLResponse {

                        if http.statusCode == 429 {
                            // retry
                            if attempt < 2 {
                                try? await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                                delaySeconds *= 2
                                continue
                            }
                            return nil
                        }

                        guard (200..<300).contains(http.statusCode) else { return nil }
                    }

                    // Store in URLCache for offline
                    if let http = response as? HTTPURLResponse {
                        let mime = (http.mimeType ?? "").lowercased()
                        if mime.hasPrefix("image/"), UIImage(data: data) != nil {
                            let cached = CachedURLResponse(response: response, data: data)
                            URLCache.shared.storeCachedResponse(cached, for: request)
                        }
                    }

                    return data
                } catch {
                    // small delay before next attempt
                    if attempt < 2 {
                        try? await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                        delaySeconds *= 2
                    }
                }
            }

            return nil
        }

        inFlight[url] = task
        let result = await task.value
        inFlight[url] = nil
        return result
    }

    private func acquireSlot() async {
        while activeCount >= maxConcurrent {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        activeCount += 1
    }

    private func releaseSlot() {
        activeCount = max(0, activeCount - 1)
    }
}
