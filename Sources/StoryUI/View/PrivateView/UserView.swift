//
//  UserView.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 29.04.2022.
//

import SwiftUI

struct UserView: View {
    
    var image: String
    var name: String
    var date: String
    
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(spacing: Constant.UserView.hStackSpace) {            
            CacheAsyncImage(urlString: image)
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(date)
                    .font(.system(size: Constant.UserView.textSize, weight: .thin))
                    .foregroundColor(.white)
            }
            
            Spacer()

            Image(systemName: "xmark")
                .font(.title)
                .foregroundColor(.white)
                .onTapGesture {
                    NotificationCenter.default.post(name: .replaceCurrentItem, object: nil)
                    isPresented = false
                }

        }
        .padding(.horizontal)
    }
}

