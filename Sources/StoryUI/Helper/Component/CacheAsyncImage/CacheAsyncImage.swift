//
//  CacheAsyncImage.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 1.05.2022.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = AsyncImageCache[url]{
            content(.success(cached))
        }else{
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success (let image) = phase {
            AsyncImageCache[url] = image
        }
        return content(phase)
    }
}

fileprivate class AsyncImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get{
            AsyncImageCache.cache[url]
        }
        set{
            AsyncImageCache.cache[url] = newValue
        }
    }
}
