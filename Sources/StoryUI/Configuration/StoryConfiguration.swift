//
//  StoryConfiguration.swift
//  
//
//  Created by Tolga İskender on 11.06.2023.
//

import Foundation

public struct StoryConfiguration: Equatable, Hashable {
    public var storyType: StoryType
    public var mediaType: StoryUIMediaType
    
    public init(storyType: StoryType = .plain, mediaType: StoryUIMediaType) {
        self.storyType = storyType
        self.mediaType = mediaType
    }
}
