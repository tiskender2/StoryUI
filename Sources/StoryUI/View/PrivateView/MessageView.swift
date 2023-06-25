//
//  SwiftUIView.swift
//
//
//  Created by Tolga İskender on 3.06.2023.
//

import SwiftUI

struct MessageView: View {
    
    // MARK: Public Properties
    @State var storyType: StoryType?
    @Binding var showEmoji: Bool
    let userClosure: UserCompletionHandler?
    
    // MARK: Private Properties
    @State private var text: String = ""
    @State private var likeButtonTapped: Bool = false
    @State private var clearText: Bool = false
   
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                switch storyType {
                case .plain(let config):
                    HStack {
                        Spacer()
                        buttonViewBuilder(config)
                    }
                case .message(let config, _, let placeholder):
                    messageViewBuilder(config, placeholder)
                default:
                    EmptyView()
                }
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
            clearText.toggle()
            userClosure?(text, nil, false)
        }
    }
    
    var likeButton: some View  {
        Button {
            likeButtonTapped.toggle()
        } label: {
            Image(systemName: likeButtonTapped ? Constant.MessageView.likeImageTapped : Constant.MessageView.likeImage)
                .font(.title2)
                .foregroundColor(likeButtonTapped ? .red : .white)
            
        }
    }
    
    var shareButton: some View  {
        Button {
        } label: {
            Image(systemName: Constant.MessageView.shareImage)
                .font(.title2)
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func buttonViewBuilder(_ config: StoryInteractionConfig?) -> some View {
        if let config {
            HStack(spacing: 16) {
                if config.showLikeButton {
                    likeButton
                }
            }
            .frame(height: Constant.MessageView.height)
        } else {
            EmptyView()
        }
    }
    
    
    func messageViewBuilder(_ config: StoryInteractionConfig?, _ placeholder: String) -> some View {
        HStack(spacing: 16) {
            TextField("",
                      text: $text,
                      onCommit: onCommitAction)
            .placeholder(when: text.isEmpty, view: {
                Text(placeholder).foregroundColor(.white)
            })
            .onChange(of: text, perform: { newValue in
                showEmoji = newValue.isEmpty
            })
            .onChange(of: clearText, perform: { newValue in
                text = ""
                showEmoji = newValue
            })
            
            .foregroundColor(.white)
            .frame(height: Constant.MessageView.height)
            .padding(Constant.MessageView.padding)
            .overlay(
                RoundedRectangle(cornerRadius: Constant.MessageView.cornerRadius)
                    .stroke(.white)
            )
            
            buttonViewBuilder(config)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(storyType: .plain(), showEmoji: .constant(true), userClosure: nil)
    }
}

