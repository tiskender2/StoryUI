//
//  EmojiReactionView.swift
//  
//
//  Created by Tolga İskender on 11.06.2023.
//

import SwiftUI

struct EmojiReactionView: View {
    @State private var showReaction = false
    @Binding var dissmis: Bool
    @Binding var isAnimationStarted: Bool
    @State var emoji: String
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                Spacer()
                ForEach((1...2).reversed(), id: \.self) { index in
                    ZStack(alignment: .bottom) {
                        ForEach((1...10).reversed(), id: \.self) { index in
                            Text(emoji)
                                .font(.system(size: 40))
                                .offset(y: getHeight(with: reader, position: 140))
                                .offset(x: getWidth(with: reader, index: index))
                                .opacity(showReaction ? 0 : 1)
                                .animation(.easeInOut(duration: Double.random(in: 2...3.5)), value: showReaction)
                        }
                    }
                }
            }
        }
        .onAppear {
            isAnimationStarted = true
            showReaction.toggle()
            performDelayedAction()
        }
    }
    
    func performDelayedAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            didCompletedAnimation()
        }
    }
    
    func didCompletedAnimation() {
        isAnimationStarted = false
        dissmis = false
    }
}

private extension EmojiReactionView {
    
    func getDelay(with index: Int) -> Double {
        return 1.0 + (Double(index - 1) * 0.10)
    }
    
    func getWidth(with reader: GeometryProxy, index: Int) -> Double {
        return reader.size.width - CGFloat(40 * index)
    }
    
    func getHeight(with reader: GeometryProxy, position: Double) -> Double {
        return showReaction ? -(reader.size.height / 2) : position
    }
    
}

struct BubblesView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiReactionView(dissmis: .constant(true),
                          isAnimationStarted: .constant(false),
                          emoji: "🤪")
            .preferredColorScheme(.dark)
    }
}
