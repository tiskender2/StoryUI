//
//  File.swift
//  
//
//  Created by Tolga İskender on 21.06.2023.
//

import Foundation

public struct StoryInteractionConfig: Equatable, Hashable {
    let showLikeButton: Bool
    
    public init(showLikeButton: Bool = false) {
        self.showLikeButton = showLikeButton
    }
    
}
