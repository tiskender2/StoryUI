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
    let mediaState: ((MediaState, Double) -> Void)?
    
    func makeUIView(context: Context) -> PlayerView {
        let playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        playerView.player = player
        playerView.mediaState = { state, duration in
            mediaState?(state, duration)
        }
        return playerView
    }
    
    func updateUIView(_ playerView: PlayerView, context: Context) {
        playerView.startVideo(url: URL(string: videoURL))
        playerView.mediaState = { state, duration in
            mediaState?(state, duration)
        }
    }
    
}
