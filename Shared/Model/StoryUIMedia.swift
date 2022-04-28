//
//  StoryUIMedia.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Foundation

public struct StoryUIMedia {
    public var url: String
    public let date: String
    public let type: StoryUIMediaType
    public var state: StoryUIMediaStateType
    
    public init(url: String, date: String, type: StoryUIMediaType, state: StoryUIMediaStateType) {
        self.url = url
        self.date = date
        self.type = type
        self.state = state
    }
}
