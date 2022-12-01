//
//  VideoView.swift
//  StoryUI
//
//  Created by Tolga İskender on 31.03.2022.
//

import SwiftUI
import AVKit

struct VideoView: UIViewRepresentable {
    
    // MARK: Public Properties
    var videoURL: String
    @Binding var state: MediaState
    let videoLength: (MediaState, Double) -> Void
    
    func makeUIView(context: Context) -> PlayerView {
        print("makeUIView")
        let playerView = PlayerView(frame: .zero)
        playerView.startVideo(url: URL(string: videoURL))
        return playerView
    }
    
    func updateUIView(_ playerView: PlayerView, context: Context) {
      
        print("updateUIView")
        playerView.restartVideo()
        playerView.videoLength = { state, duration in
            self.videoLength(state,playerView.duration)
        }
    }
    
}
