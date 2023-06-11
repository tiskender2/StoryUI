//
//  SwiftUIView.swift
//
//
//  Created by Tolga İskender on 1.05.2022.
//

import SwiftUI
import AVKit

struct StoryDetailView: View {
    // MARK: Public Properties
    @EnvironmentObject var storyData: StoryViewModel
    
    @Binding var model: StoryUIModel
    @Binding var isPresented: Bool
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress: CGFloat = 0
    
    let userClosure: UserCompletionHandler?
    
    // MARK: Private Properties
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var state: MediaState = .notStarted
    @State private var player = AVPlayer()
    @State private var animate = false
    @State private var startAnimate = false
    
    private var messageViewPosition: CGFloat {
        return -keyboardManager.currentHeight
    }
    
    private var emojiViewPosition: CGFloat {
        return (messageViewPosition * 1.5)
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            let index = getCurrentIndex()
            let story = model.stories[index]
            ZStack {
                if model.stories.count > index {
                    VStack(spacing: 8) {
                        getStoryView(with: index, story: story)
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
                        MessageView(storyType: story.config.storyType, userClosure: userClosure)
                            .padding()
                            .animation(messageViewPosition == 0 ? .none : .easeOut)
                            .offset(y: messageViewPosition)
                    }
                }
                getEmojiView(story: story)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
            //startProgress()
        }
    }
}

// MARK: Private Configuration
private extension StoryDetailView {
    
    @ViewBuilder
    func getStoryView(with index: Int, story: Story) -> some View {
        switch story.config.mediaType {
        case .image:
            ImageView(imageURL: story.mediaURL) {
                start(index: index)
            }
            .onAppear() {
                resetAVPlayer()
            }
        case .video:
            VideoView(videoURL: story.mediaURL, state: $state, player: player) { media, duration in
                model.stories[index].duration = duration
                start(index: index)
            }.onAppear() {
                playVideo()
            }
        }
    }
    
    @ViewBuilder
    func getEmojiView(story: Story) -> some View {
        switch story.config.storyType {
        case .message(let emojis, _):
            if let emojis {
                VStack {
                    Spacer()
                    EmojiView(emojiArray: emojis,
                              startAnimating: $startAnimate,
                              userClosure: userClosure)
                    .animation(messageViewPosition == 0 ? .none : .easeOut)
                    .offset(y: emojiViewPosition)
                    .opacity(messageViewPosition == 0 ? 0 : 1)
                }
                
                if startAnimate {
                    EmojiReactionView()
                }
                
            }
        case .plain:
            Divider()
        }
        
    }
    
    func getAngle(proxy: GeometryProxy) -> Angle {
        let rotation: CGFloat = 45
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let degrees = rotation * progress
        return Angle(degrees: degrees)
    }
    
    func resetProgress() {
        timerProgress = 0
    }
    
    func getPreviousStory() {
        
        if let first = storyData.stories.first, first.id != model.id {
            
            let bundleIndex = storyData.stories.firstIndex { currentBundle in
                return model.id == currentBundle.id
            } ?? 0
            
            withAnimation {
                storyData.currentStoryUser = storyData.stories[bundleIndex - 1].id
            }
        } else {
            let index = getCurrentIndex()
            if model.stories[index].config.mediaType == .video {
                NotificationCenter.default.post(name: .stopAndRestartVideo, object: nil)
                resetProgress()
            }
        }
        return
    }
    
    func getNextStory() {
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
    
    func startProgress() {
        let index = getCurrentIndex()
        if storyData.currentStoryUser == model.id {
            if !model.isSeen {
                model.isSeen = true
            }
            if timerProgress < CGFloat(model.stories.count) {
                if model.stories[index].isReady {
                    getProgressBarFrame(duration: model.stories[index].duration)
                }
            } else {
                updateStory()
            }
        }
    }
    
    func updateStory(direction: StoryDirectionEnum = .next) {
        if direction == .previous {
            getPreviousStory()
        } else {
            getNextStory()
        }
    }
    
    func tapNextStory() {
        if (timerProgress + 1) > CGFloat(model.stories.count) {
            //next user
            updateStory()
        } else {
            //next Story
            timerProgress = CGFloat(Int(timerProgress + 1))
        }
    }
    
    func tapPreviousStory() {
        if (timerProgress - 1) < 0 {
            updateStory(direction: .previous)
        } else {
            timerProgress = CGFloat(Int(timerProgress - 1))
        }
    }
    
    func start(index: Int) {
        if !model.stories[index].isReady {
            model.stories[index].isReady = true
        }
    }
    
    func getProgressBarFrame(duration: Double) {
        let calculatedDuration = storyData.getVideoProgressBarFrame(duration: duration)
        timerProgress += (0.01 / calculatedDuration)
    }
    
    func dissmis() {
        isPresented = false
    }
    
    func getCurrentIndex() -> Int {
        return min(Int(timerProgress), model.stories.count - 1)
    }
    
    func resetAVPlayer() {
        player.pause()
        player = AVPlayer()
    }
    
    func playVideo() {
        player.play()
    }
}
