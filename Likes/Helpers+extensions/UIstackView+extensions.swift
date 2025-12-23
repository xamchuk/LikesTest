//
//  UIstackView+extensions.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import UIKit.UIStackView

extension UIStackView {
    
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    func spacing(_ spacing: Double) -> Self {
        self.spacing = spacing
        return self
    }
    
    @discardableResult
    func alignment(_ alignment:  UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
}
