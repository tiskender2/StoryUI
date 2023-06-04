//
//  SwiftUIView.swift
//
//
//  Created by Tolga İskender on 3.06.2023.
//

import SwiftUI

struct MessageView: View {
    
    
    // MARK: Private Properties
    @State private var text: String = ""
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, view: {
                        Text("Send Message").foregroundColor(.white)
                    })
                    .foregroundColor(.white)
                    .frame(height: Constant.MessageView.height)
                    .padding(Constant.MessageView.padding)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constant.MessageView.cornerRadius)
                            .stroke(.white)
                    )
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

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}

