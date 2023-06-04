//
//  TextField+Extension.swift
//  
//
//  Created by Tolga İskender on 3.06.2023.
//

import Foundation
import SwiftUI

extension TextField {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder view: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                view().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
