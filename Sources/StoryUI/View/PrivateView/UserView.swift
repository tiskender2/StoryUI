//
//  UserView.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 29.04.2022.
//

import SwiftUI

struct UserView: View {
    
    var model: StoryUIModel
    var date: String
    
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(spacing: Constant.UserView.hStackSpace) {            
            CacheAsyncImage(urlString: model.user.image)
            VStack(alignment: .leading) {
                Text(model.user.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(date)
                    .font(.system(size: Constant.UserView.textSize, weight: .thin))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                NotificationCenter.default.post(name: .replaceCurrentItem, object: nil)
                isPresented = false
            }, label: {
                Image(systemName: Constant.UserView.closeImage)
                    .font(.title)
                    .foregroundColor(.white)
            })
        }
        .padding(.horizontal)
    }
}

