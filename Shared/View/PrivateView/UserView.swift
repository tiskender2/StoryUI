//
//  UserView.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 29.04.2022.
//

import SwiftUI

struct UserView: View {
    
    var profileImage: String
    var profileName: String
    @EnvironmentObject var storyData: StoryViewModel
    
    var body: some View {
        HStack(spacing: 13) {
            Image(profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            Text(profileName)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                storyData.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .padding()
                    .font(.title2)
                    .foregroundColor(.white)
            })
        }
        .padding()
    }
}

