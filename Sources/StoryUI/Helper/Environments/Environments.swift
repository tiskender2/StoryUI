//
//  Environments.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
    static let imageCache = NSCache<AnyObject, AnyObject>()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}
