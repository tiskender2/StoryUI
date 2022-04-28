//
//  StoryView.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 28.04.2022.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var storyData: StoryViewModel
    
    var body: some View {
        if storyData.showStory {
            TabView(selection: $storyData.currentStory) {
                ForEach($storyData.stories) { $bundle in
                    
                    StoryCardView(bundle: $bundle)
                        .environmentObject(storyData)
                    
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .transition(.move(edge: .bottom))
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct StoryCardView: View {
    @Binding var bundle: StoryBundle
    @EnvironmentObject var storyData: StoryViewModel
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                let index = min(Int(timerProgress), bundle.stories.count - 1)
                
                if let story = bundle.stories[index] {
                    Image(story.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
                UserView(profileImage: bundle.profileImage,
                         profileName: bundle.profileName)
                .environmentObject(storyData)
                ,alignment: .topTrailing
            )
            .overlay(
                HStack(spacing: 5) {
                    ForEach(bundle.stories.indices) { index in
                        ProgressView(timerProgress: timerProgress,
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
            resetProgress()
        })
        
        .onReceive(timer) { _ in
            if storyData.currentStory == bundle.id {
                if !bundle.isSeen {
                    bundle.isSeen = true
                }
                startProgress()
            }
        }
    }
    
}

extension StoryCardView {
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
        
        if let first = storyData.stories.first, first.id != bundle.id {
            
            let bundleIndex = storyData.stories.firstIndex { currentBundle in
                return bundle.id == currentBundle.id
            } ?? 0
            
            withAnimation {
                storyData.currentStory = storyData.stories[bundleIndex - 1].id
            }
            
        } else {
            resetProgress()
        }
        return
    }
    
    private func getNextStory() {
        let index = min(Int(timerProgress), bundle.stories.count - 1)
        let story = bundle.stories[index]
        
        if let last = bundle.stories.last, last.id == story.id {
            if let lastBundle = storyData.stories.last, lastBundle.id == bundle.id {
                withAnimation {
                    storyData.showStory = false
                }
            } else {
                let bundleIndex = storyData.stories.firstIndex { currentBundle in
                    return bundle.id == currentBundle.id
                } ?? 0
                
                withAnimation {
                    storyData.currentStory = storyData.stories[bundleIndex + 1].id
                }
            }
        }
    }
    
    private func startProgress() {
        if timerProgress < CGFloat(bundle.stories.count) {
            timerProgress += 0.03
        } else {
            updateStory()
        }
    }
    
    private func updateStory(direction: StoryDirectionEnum = .next) {
        if direction == .previous {
            getPreviousStory()
        }
        getNextStory()
    }
    
    private func tapNextStory() {
        if (timerProgress + 1) > CGFloat(bundle.stories.count) {
            //nest user
            updateStory()
        } else {
            //nextStory
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
}
