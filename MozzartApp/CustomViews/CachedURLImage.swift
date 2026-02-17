//
//  CachedURLImage.swift
//  MozzartApp
//
//  Created by suncica on 17. 2. 2026..
//

import SwiftUI

struct CachedURLImage<Fallback: View>: View {
    let url: URL
    let fallback: () -> Fallback

    @State private var image: Image?

    init(url: URL, @ViewBuilder fallback: @escaping () -> Fallback) {
        self.url = url
        self.fallback = fallback
    }

    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                fallback()
            }
        }
        .task(id: url.absoluteString) {
            await load()
        }
        
        
    }

     private func load() async {
         // image exist - do nothing
         if image != nil { return }

         if let data = await SharedImageLoader.shared.data(for: url),
            let uiImage = UIImage(data: data) {
             await MainActor.run {
                 image = Image(uiImage: uiImage)
             }
         }
     }
}
