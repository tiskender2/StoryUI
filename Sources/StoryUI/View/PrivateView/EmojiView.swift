//
//  SwiftUIView.swift
//  
//
//  Created by Tolga İskender on 4.06.2023.
//

import SwiftUI

struct EmojiView: View {
    
    var emojiArray: [[String]]?
    
    @Binding var startAnimating: Bool
    
    let userClosure: UserCompletionHandler?
    
    private var emojiSize: CGFloat {
        if emojiArray?.count == 1 {
            return 55
        }
        return CGFloat(100/(emojiArray?.count ?? .zero))
    }
    
    private var spacing: CGFloat {
        if emojiArray?.count == 1 {
            return 40
        }
        return CGFloat(80/(emojiArray?.count ?? .zero))
    }
    
    var body: some View {
        if let emojiArray {
            VStack(spacing: spacing) {
                ForEach(emojiArray.lazy.indices) { index in
                    HStack(spacing: spacing) {
                        ForEach(emojiArray[index].lazy.indices) { icon in
                            Button(emojiArray[index][icon]) {
                                let emoji = emojiArray[index][icon]
                                startAnimate()
                                dismissKeyboard()
                                userClosure?(nil, emoji, false, false)
                            }
                            .font(.system(size: emojiSize))
                        }
                    }
                }
            }
        }
        
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
    }
    
    private func startAnimate() {
       startAnimating = true
    }
}

struct EmojiView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiView(emojiArray: [["😂", "😮", "😍"]],
                  startAnimating: .constant(false),
                  userClosure: nil)
    }
}
