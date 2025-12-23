//
//  HeaderView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import UIKit

final class HeaderView: UIView {
    
    // MARK: - Views -
    private let titleLabel = LikesFactory.Labels.h1()
    
    // MARK: - Init -
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    func setup(title: String) {
        self.backgroundColor(.lWhite)
        titleLabel
            .set(text: title, kernPx: 0)
            .lineHeight(42)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}