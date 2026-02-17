//
//  PlaceholderImageCircle.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

 struct PlaceholderImageCircle: View {

    let url: URL?
    let fallbackText: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.10))

            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Text(fallbackText)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.white.opacity(0.85))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Text(fallbackText)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.white.opacity(0.85))
                    @unknown default:
                        Text(fallbackText)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.white.opacity(0.85))
                    }
                }
                .clipShape(Circle())
            } else {
                Text(fallbackText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.white.opacity(0.85))
            }
        }
        .clipShape(Circle())
    }
}
