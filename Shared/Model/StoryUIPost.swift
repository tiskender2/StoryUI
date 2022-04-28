//
//  StoryUIPostModel.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Foundation

public struct StoryUIPost: Identifiable {
    public var id = UUID().uuidString
    public var user: StoryUIUser
    public var media: [StoryUIMedia]
    public var seen: Bool
    public var loading: Bool
    
    public init(user: StoryUIUser, media: [StoryUIMedia], seen: Bool, loading: Bool) {
        self.user = user
        self.media = media
        self.seen = seen
        self.loading = loading
        self.id = UUID().uuidString
    }
}

