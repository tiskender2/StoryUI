//
//  User.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 1.05.2022.
//

import Foundation

public struct User: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var name: String
    public var image: String
    
    public init(id: String = UUID().uuidString, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
