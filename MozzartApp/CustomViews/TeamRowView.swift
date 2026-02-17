//
//  TeamRowView.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

struct TeamRowView: View {
    let name: String
    let avatarURL: URL?

    var body: some View {
        HStack(spacing: 10) {

            if let rasterURL = ImageURLHelper.rasterURLIfDicebearSVG(avatarURL) {
               CachedURLImage(url: rasterURL) {
                   InitialsCircle(name: name, size: 13)
              }
                .frame(width: 28, height: 28)
                .clipShape(Circle())
            } else {
                InitialsCircle(name: name, size: 13)
            }

            Text(name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.92))
                .lineLimit(1)
        }
    }
}
