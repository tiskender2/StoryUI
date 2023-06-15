//
//  SwiftUIView.swift
//
//
//  Created by Tolga İskender on 3.06.2023.
//

import SwiftUI

struct MessageView: View {
    
    // MARK: Public Properties
    @State var storyType: StoryType
   // @Binding var isTimerRunning: Bool
    let userClosure: UserCompletionHandler?
    
    // MARK: Private Properties
    @State private var text: String = ""
    
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                switch storyType {
                case .plain:
                    Spacer()
                        .frame(height: Constant.MessageView.height)
                case .message(_, let placeholder):
                    TextField("",
                              text: $text,
                              onCommit: onCommitAction)
                    .placeholder(when: text.isEmpty, view: {
                        Text(placeholder).foregroundColor(.white)
                    })
                    .foregroundColor(.white)
                    .frame(height: Constant.MessageView.height)
                    .padding(Constant.MessageView.padding)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constant.MessageView.cornerRadius)
                            .stroke(.white)
                    )
                }
            }
            
            Button {
            } label: {
                Image(systemName: Constant.MessageView.likeImage)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            Button {
            } label: {
                Image(systemName: Constant.MessageView.shareImage)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
        }
    }
}

private extension MessageView {
    var onCommitAction: () -> Void {
        return {
            guard !text.isEmpty else {
                return
            }
            
            userClosure?(text, nil, false, false)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(storyType: .plain, userClosure: nil)
    }
}

