//
//  UIButton+Extensions.swift
//  GoQii
//
//  Created by Neosoft on 03/05/24.
//

import Foundation
import UIKit

extension UIButton {
    func applyCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyShadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = .zero, radius: CGFloat = 4.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    func applyOpacity(_ alpha: CGFloat) {
        self.alpha = alpha
    }
}
