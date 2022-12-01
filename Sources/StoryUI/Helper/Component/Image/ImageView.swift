//
//  StoryUIImageView.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import SwiftUI
import AVKit

struct ImageView: UIViewRepresentable {
    
    var imageURL: String
    let imageIsLoaded: () -> Void
   
    
    func makeUIView(context: UIViewRepresentableContext<ImageView>) -> ImageLoader {
        return ImageLoader()
    }
    
    func updateUIView(_ uiView: ImageLoader, context: Context) {
        print("ImageLoader")
       // NotificationCenter.default.post(name: .stopVideo2, object: nil)
        uiView.loadImageWithUrl(imageURL, imageIsLoaded: imageIsLoaded)
    }
    
}
