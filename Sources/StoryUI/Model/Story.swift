//
//  StoryUIUser.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Foundation

public struct Story: Identifiable, Hashable {
    public var id: String
    public var mediaURL: String
    public var date: String
    public var type: StoryUIMediaType
    public var isReady: Bool = false
    public var duration: Double = Constant.storySecond
    
    public init(id: String = UUID().uuidString, mediaURL: String, date: String, type: StoryUIMediaType, isReady: Bool = false, duration: Double = 5) {
        self.id = id
        self.mediaURL = mediaURL
        self.date = date
        self.type = type
        self.isReady = isReady
        self.duration = duration
        Constant.storySecond = duration
    }
}

