//
//  StoryViewModel.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 28.04.2022.
//

import Foundation

final class StoryViewModel: ObservableObject {
    
    @Published var currentStoryUser: String = ""
    @Published var stories: [StoryUIModel] = []
    
    func getVideoProgressBarFrame(duration: Double) -> Double {
        return duration * 0.1 // convert any second to  between 0 - 1 second
    }
    
    func getStoryModel() -> StoryUIModel? {
        if let i = stories.firstIndex(where: { $0.id == currentStoryUser }) {
            return stories[i]
        }
        return nil
    }
    
    func getStories() -> [Story]? {
        return getStoryModel()?.stories
    }
    
    func getStory(with index: Int) -> Story? {
        return getStories()?[index]
    }
}
