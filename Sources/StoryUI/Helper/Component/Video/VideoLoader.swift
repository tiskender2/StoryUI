//
//  VideoLoader.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 30.04.2022.
//

import Foundation
import UIKit
import AVKit

class PlayerView: UIView {
    
    // MARK: Public Properties
    var player: AVPlayer?
    var duration: Double = 0.0
    var state: MediaState = .notStarted
    var videoLength: ((MediaState,Double) -> ())?
    
    // MARK: Private Properties
    private let playerLayer = AVPlayerLayer()
    private var previewTimer: Timer?
    private var url: URL?
    
     // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    func startVideo(url: URL?) {
        guard let validatedUrl = url else { return }
        if self.url == url { return }
        self.url = validatedUrl
        addActivityIndicatory()
        addObserverToVideo()
        // stop video if it's playing before video request
        stopVideo()
        guard let url = url else { return }
        CacheManager.shared.getFileWith(stringUrl: url.absoluteString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                self.setupPlayer(url)
            case .failure(let error):
                print(error)
            }
        }
    }
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus" {
            if player?.timeControlStatus == .playing {
                removeActivityIndicatory()
                videoLength?(state, duration)
            } else if player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                addActivityIndicatory()
            }
        }
    }
    
    func getVideoLength(videoURL: URL) {
        duration = AVURLAsset(url: videoURL).duration.seconds
    }
    
    private func stopAndRestartVideo() {
        player?.seek(to: .zero)
    }
    
    private func stopVideo() {
        if player?.timeControlStatus == .playing {
            player?.pause()
            player?.seek(to: .zero)
        }
    }
    
    func restartVideo() {
        if player?.timeControlStatus == .paused {
            player?.seek(to: .zero)
            player?.play()
            state = .restart
        }
    }
    

    
    private func setupPlayer(_ url: URL) {
        self.player?.replaceCurrentItem(with: nil)
        self.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
        self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        self.getVideoLength(videoURL: url)
        if player?.timeControlStatus != .playing {
            self.player?.play()
        }
        self.playerLayer.player = self.player
        self.playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.removeFromSuperlayer()
        self.layer.addSublayer(self.playerLayer)
    }
    
    private func addObserverToVideo() {
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideoObserver), name: .restartVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopVideoObserver), name: .stopVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAndRestartVideoObserver), name: .stopAndRestartVideo, object: nil)
    }
}

extension PlayerView {
    fileprivate func addActivityIndicatory() {
        removeActivityIndicatory()
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        view.tag = 999
        self.addSubview(view)
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = UIColor.lightGray.withAlphaComponent(0.7)
        activityView.frame = CGRect(x: w / 2, y: h / 2, width: .zero, height: .zero)
        view.addSubview(activityView)
        addConst(view: activityView)
        activityView.startAnimating()
    }
    
    fileprivate func removeActivityIndicatory() {
       self.subviews.forEach { (view) in
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
    }
    
    fileprivate func addConst(view: UIActivityIndicatorView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: view.superview!.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: view.superview!.centerYAnchor)
        ])
    }
    
    @objc private func stopAndRestartVideoObserver() {
        stopAndRestartVideo()
    }
    
    @objc private func restartVideoObserver() {
        restartVideo()
    }
    
    @objc private func stopVideoObserver() {
        stopVideo()
    }
    
}
