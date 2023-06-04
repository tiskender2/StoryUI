//
//  SwiftUIView.swift
//  
//
//  Created by Tolga İskender on 4.06.2023.
//

import SwiftUI

struct EmojiView: View {
    
    private var emojiArray = [["😂", "😮", "😍"],
                              ["😢", "👏", "🔥"]]
    var body: some View {
        VStack(spacing: 40) {
            ForEach(emojiArray.lazy.indices) { index in
                HStack(spacing: 40) {
                    ForEach(emojiArray[index].lazy.indices) { icon in
                        Button(emojiArray[index][icon]) {
                            print(emojiArray[index][icon])
                        }
                        .font(.system(size: 55))
                    }
                }
            }
        }
    }
}

struct EmojiView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiView()
    }
}
