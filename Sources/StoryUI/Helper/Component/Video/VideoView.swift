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
    var player: AVPlayer
    let videoLength: (MediaState, Double) -> Void
    
    func makeUIView(context: Context) -> PlayerView {
        let playerView = PlayerView(frame: .zero)
        playerView.player = player
        return playerView
    }
    
    func updateUIView(_ playerView: PlayerView, context: Context) {
      
       // print("updateUIView")
        playerView.startVideo(url: URL(string: videoURL))
        playerView.videoLength = { state, duration in
            self.videoLength(state,playerView.duration)
        }
    }
    
}
