//
//  Constant.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 29.04.2022.
//

import Foundation
import UIKit
import SwiftUI

enum Constant {
    static let progressBarHeight: CGFloat = 3
    static var storySecond: Double = 5.0
    static let progressBarSpacing: CGFloat = 5
    
    enum UserView {
        static let hStackSpace: CGFloat = 13
        static let textSize: CGFloat = 16
        static let closeImage: String = "xmark"
    }
    
    enum MessageView {
        static let height: CGFloat = 48
        static let padding = EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        static let cornerRadius: CGFloat = 24
        static let likeImage: String = "heart"
        static let likeImageTapped: String = "heart.fill"
        static let shareImage: String = "paperplane"
    }
    
}
