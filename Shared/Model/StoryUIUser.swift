//
//  StoryUIUser.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Foundation

public struct StoryUIUser: Identifiable {
    public let id : Int
    public let name : String
    public let profilPicture : String
    
    public init(id: Int, name: String, profilPicture: String) {
        self.id = id
        self.name = name
        self.profilPicture = profilPicture
    }
    
}
