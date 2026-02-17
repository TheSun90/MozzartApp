//
//  SectionHeader.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

 struct SectionHeader: View {

    let title: String

    var body: some View {
        HStack(spacing: 7) {
            Rectangle()
                .fill(Color.selectedYellow)
                .frame(width: 1.5, height: 18)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.90))

            Spacer(minLength: 0)
        }
        .padding(.top, 6)
    }
}
