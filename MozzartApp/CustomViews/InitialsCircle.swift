//
//  InitialsCircle.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

struct InitialsCircle: View {
    let name: String
    let size: CGFloat

    var body: some View {
        Text(name.initials)
            .font(.system(size: size * 0.45, weight: .bold))
            .foregroundStyle(Color.white.opacity(0.9))
            .frame(width: size, height: size)
            .background(Color.white.opacity(0.10))
            .clipShape(Circle())
    }
}
