//
//  StoryViewModel.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 28.04.2022.
//

import Foundation

class StoryViewModel: ObservableObject {
    
    @Published var showStory: Bool = false
    @Published var currentStory: String = ""
    
    @Published var stories = [
        StoryBundle(profileName: "tolga", profileImage: "img1",stories: [
            Story(imageURL: "p1"),
            Story(imageURL: "p2"),
            Story(imageURL: "p3"),
        ]),
        StoryBundle(profileName: "don joe", profileImage: "img2",stories: [
            Story(imageURL: "p4"),
            
        ]),
        
        StoryBundle(profileName: "don joe", profileImage: "img2",stories: [
            Story(imageURL: "p4"),
            Story(imageURL: "p1"),
            Story(imageURL: "p2"),
            Story(imageURL: "p3"),
        ]),
    ]
}


struct StoryBundle: Identifiable, Hashable {
    var id = UUID().uuidString
    var profileName: String
    var profileImage: String
    var isSeen: Bool = false
    var stories: [Story]
}

struct Story: Identifiable, Hashable {
    var id = UUID().uuidString
    var imageURL: String
}
