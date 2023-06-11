//
//  EmojiReactionView.swift
//  
//
//  Created by Tolga İskender on 11.06.2023.
//

import SwiftUI


struct EmojiReactionView: View {
    @State private var showReaction = false
    
    var body: some View {
        GeometryReader { reader in
            VStack(spacing: 0) {
                Spacer()
                ForEach((1...2).reversed(), id: \.self) { index in
                    ZStack(alignment: .bottom) {
                        ForEach((1...10).reversed(), id: \.self) { index in
                            Text("🤪")
                                .font(.system(size: 40))
                                .offset(y: getHeight(with: reader, position: 140))
                                .offset(x: getWidth(with: reader, index: index))
                                .opacity(showReaction ? 0.5 : 1)
                                .animation(.easeInOut(duration: Double.random(in: 0.5...2))
                                           .delay(1), value: showReaction)
                        }
                    }
                }
            }
        }
        .onAppear{
            showReaction.toggle()
        }
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
        return showReaction ? -(reader.size.height/2) : position
        
    }
    
    
    
}

struct BubblesView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiReactionView()
            .preferredColorScheme(.dark)
    }
}
