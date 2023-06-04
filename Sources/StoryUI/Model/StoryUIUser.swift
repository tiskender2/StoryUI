//
//  User.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 1.05.2022.
//

import Foundation

public struct StoryUIUser: Identifiable, Hashable {
    public var id: String
    public var name: String
    public var image: String
    
    public init(id: String = UUID().uuidString, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
