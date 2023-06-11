//
//  Enums.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Foundation

// MARK: - StoryType
public enum StoryType: Equatable, Hashable {
    case plain
    case message(emojis:[[String]]? = nil, placeholder: String)
}

// MARK: - StoryUIMediaType
public enum StoryUIMediaType {
    case image
    case video
}

// MARK: - StoryUIMediaStateType
public enum StoryUIMediaStateType {
    case seen
    case notSeen
}

// MARK: - StoryDirectionEnum
enum StoryDirectionEnum {
    case previous
    case next
}

 // MARK: - MediaState
enum MediaState {
    case started
    case notStarted
    case restart
}


