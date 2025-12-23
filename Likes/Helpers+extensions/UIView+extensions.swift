//
//  UIView+extensions.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit.UIView

// Customise
extension UIView {
    
    @discardableResult
    func backgroundColor(_ bgColor: UIColor) -> Self {
        self.backgroundColor = bgColor
        return self
    }
    
    @discardableResult
    func corner(_ cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        return self
    }
}

// MARK: - Constraints -
extension UIView {
    @discardableResult
    func addAndFill(_ parent: UIView, edges: UIEdgeInsets = .zero) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: edges.top),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: edges.left),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -edges.right),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -edges.bottom)
        ])
        return self
    }
}
