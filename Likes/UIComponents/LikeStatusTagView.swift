//
//  LikeStatusTagView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import UIKit

final class LikeStatusTagView: UIView {
    
    // MARK: - Init -
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        setup(backgroundColor: backgroundColor, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup -
    private func setup(backgroundColor: UIColor, title: String) {
        self.backgroundColor(backgroundColor)
            .corner(8)
        
        let goalLabel = LikesFactory.Labels.b2Medium(size: 10, color: .lBlack)
        
        goalLabel.addAndFill(self, edges: .init(top: 4,
                                                left: 6,
                                                bottom: 4,
                                                right: 6))
        goalLabel.set(text: title, kernPx: 0)
            .lineHeight(12)
    }
}
