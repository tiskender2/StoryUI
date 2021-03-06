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
        HStack(spacing: 13) {            
            CacheAsyncImage(urlString: bundle.user.image)
            VStack(alignment: .leading) {
                Text(bundle.user.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(date)
                    .font(.system(size: 16, weight: .thin))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
            })
        }
        .padding()
    }
}

