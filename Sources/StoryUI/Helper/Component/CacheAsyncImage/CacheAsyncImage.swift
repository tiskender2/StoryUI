//
//  CacheAsyncImage.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 1.05.2022.
//

import SwiftUI

struct CacheAsyncImage: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        if  urlImageModel.image != nil {
            Image(uiImage: urlImageModel.image!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else {
            Color.gray.opacity(0.8)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
    }
}


final class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?

    init(urlString: String?) {
        self.urlString = urlString
        downloadPhoto()
    }

    private func downloadPhoto() {
        guard let urlString, let url = URL(string: urlString) else { return }

        if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
            self.image = .init(data: cachedResponse.data)
        } else {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data, let response else { return }

                URLCache.shared.storeCachedResponse(
                    .init(response: response, data: data),
                    for: .init(url: url)
                )

                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
