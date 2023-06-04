//
//  UIApplication.swift
//  
//
//  Created by Tolga İskender on 4.06.2023.
//

import Foundation
import UIKit.UIApplication

extension UIApplication {
    
    static var topSafeAreaHeight: CGFloat {
        return self.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    
    static var bottomSafeAreaHeight: CGFloat {
       return self.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
}
