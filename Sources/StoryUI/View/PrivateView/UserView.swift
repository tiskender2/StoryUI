//
//  UserView.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 29.04.2022.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var storyData: StoryViewModel
    
    var bundle: StoryUIModel
    var date: String
    
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(spacing: Constant.UserView.hStackSpace) {            
            CacheAsyncImage(urlString: bundle.user.image)
            VStack(alignment: .leading) {
                Text(bundle.user.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(date)
                    .font(.system(size: Constant.UserView.textSize, weight: .thin))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: Constant.UserView.closeImage)
                    .font(.title)
                    .foregroundColor(.white)
            })
        }
        .padding()
    }
}

