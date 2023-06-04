//
//  MessageDetailView.swift
//  
//
//  Created by Tolga İskender on 4.06.2023.
//

import SwiftUI

struct MessageDetailView: View {
    @Binding var showMessageDetail: Bool
    var body: some View {
        VStack {
            Color.red.opacity(0.5)
            MessageView()
                .padding()
        }
    }
}

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(showMessageDetail: .constant(false))
    }
}
