//
//  SwiftUIView.swift
//  
//
//  Created by Tolga İskender on 1.05.2022.
//

import SwiftUI

struct StoryDetailView: View {
    @EnvironmentObject var storyData: StoryViewModel
    
    @Binding var model: StoryUIModel
    @Binding var isPresented: Bool
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress: CGFloat = 0
    @State private var state: MediaState = .notStarted
    
    var body: some View {
        
        GeometryReader { proxy in
            let index = getCurrentIndex()
            ZStack {
                if let story = model.stories[index] {
                    switch story.type {
                    case .image:
                        ImageView(imageURL: story.mediaURL) {
                            start(index: index)
                        }
                    case .video:
                        VideoView(videoURL: story.mediaURL, state: $state) { media, duration in
                            model.stories[index].duration = duration
                            start(index: index)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(
                HStack {
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            tapPreviousStory()
                        }
                    
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            tapNextStory()
                        }
                }
            )
            .overlay(
                UserView(bundle: model,
                         date: model.stories[index].date,
                         isPresented: $isPresented)
                .environmentObject(storyData)
                ,alignment: .topTrailing
            )
            .overlay(
                HStack(spacing: Constant.progressBarSpacing) {
                    ForEach(model.stories.indices) { index in
                        ProgressBarView(timerProgress: timerProgress,
                                        index: index)
                    }
                }
                .padding(.horizontal)
                
                ,alignment: .top
            )
            .rotation3DEffect(getAngle(proxy: proxy),
                              axis: (x: 0, y: 1, z: 0),
                              anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                              perspective: 2.5)
        }
        .onAppear(perform: {
            NotificationCenter.default.post(name: .stopVideo, object: nil)
            resetProgress()
        })
        .onReceive(timer) { _ in
            startProgress()
        }
    }
    
}

extension StoryDetailView {
    private func getAngle(proxy: GeometryProxy) -> Angle {
        let rotation: CGFloat = 45
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let degrees = rotation * progress
        return Angle(degrees: degrees)
    }
    
    private func resetProgress() {
        timerProgress = 0
    }
    
    private func getPreviousStory() {
        
        if let first = storyData.stories.first, first.id != model.id {
            
            let bundleIndex = storyData.stories.firstIndex { currentBundle in
                return model.id == currentBundle.id
            } ?? 0
            
            withAnimation {
                storyData.currentStoryUser = storyData.stories[bundleIndex - 1].id
            }
        } else {
            let index = getCurrentIndex()
            if model.stories[index].type == .video {
                NotificationCenter.default.post(name: .stopAndRestartVideo, object: nil)
                resetProgress()
            }
        }
        return
    }
    
    private func getNextStory() {
        let index = getCurrentIndex()
        let story = model.stories[index]
        
        if let last = model.stories.last, last.id == story.id {
            if let lastBundle = storyData.stories.last, lastBundle.id == model.id {
                withAnimation {
                    dissmis()
                }
            } else {
                let bundleIndex = storyData.stories.firstIndex { currentBundle in
                    return model.id == currentBundle.id
                } ?? 0
                
                withAnimation {
                    storyData.currentStoryUser = storyData.stories[bundleIndex + 1].id
                }
            }
        }
    }
    
    private func startProgress() {
        let index = getCurrentIndex()
        if storyData.currentStoryUser == model.id {
            if !model.isSeen {
                model.isSeen = true
            }
            if timerProgress < CGFloat(model.stories.count) {
                if model.stories[index].isReady {
                    getProgressBarFrame(duration: model.stories[index].duration)
                    if model.stories[index].type == .image {
                        NotificationCenter.default.post(name: .stopVideo, object: nil)
                    }
                }
            } else {
                updateStory()
            }
        }
    }
    
    private func updateStory(direction: StoryDirectionEnum = .next) {
        if direction == .previous {
            getPreviousStory()
        } else {
            getNextStory()
        }
    }
    
    private func tapNextStory() {
        if (timerProgress + 1) > CGFloat(model.stories.count) {
            //next user
            updateStory()
        } else {
            //next Story
            timerProgress = CGFloat(Int(timerProgress + 1))
        }
    }
    
    private func tapPreviousStory() {
        if (timerProgress - 1) < 0 {
            updateStory(direction: .previous)
        } else {
            timerProgress = CGFloat(Int(timerProgress - 1))
        }
    }
    
    private func start(index: Int) {
        if !model.stories[index].isReady {
            model.stories[index].isReady = true
        }
    }
    
    private func getProgressBarFrame(duration: Double) {
        let calculatedDuration = storyData.getVideoProgressBarFrame(duration: duration)
        timerProgress += (0.01 / calculatedDuration)
    }
    
    private func dissmis() {
        isPresented = false
    }
    
    private func getCurrentIndex() -> Int {
        return min(Int(timerProgress), model.stories.count - 1)
    }
}
