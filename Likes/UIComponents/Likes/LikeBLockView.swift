//
//  LikeBLockView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 23.12.2025.
//


import UIKit

final class LikeBLockView: UIView {
    
    // MARK: - Properties -
    private let onUnblurTap: () -> Void
    private let onGoToFinderTap: () -> Void
    
    // MARK: - Init -
    init(onUnblurTap: @escaping () -> Void, onGoToFinderTap: @escaping () -> Void) {
        self.onUnblurTap = onUnblurTap
        self.onGoToFinderTap = onGoToFinderTap
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    private func setup() {
        // TODO: - Create real images with blur and fade, It will save app's size
        // To save a bit time - I'm just using mock image from figma
    
        let blurImageView = UIImageView(image: .mockBlur)
        self.addSubview(blurImageView)
        blurImageView.translatesAutoresizingMaskIntoConstraints = false
        blurImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            blurImageView.topAnchor.constraint(equalTo: topAnchor),
            blurImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        let titleLabel = LikesFactory.Labels.b2Bold(size: 28, color: .lBlack)
        titleLabel.textAlignment = .center
        let subtitleLabel = LikesFactory.Labels.b2Regular(size: 14)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        titleLabel.set(text: "See them on Finder", kernPx: 0)
            .lineHeight(35)
        subtitleLabel.set(text: "Find people who liked you on Finder or Unblur all likes now", kernPx: 0)
            .lineHeight(18)
        
        let labelsHStack = UIStackView(arrangedSubviews: [
            titleLabel, subtitleLabel
        ])
            .axis(.vertical)
            .spacing(8)
        
        labelsHStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelsHStack)
        
        NSLayoutConstraint.activate([
            labelsHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 182),
            labelsHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelsHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])
        
        let goToFinderButton = LikesFactory.Buttons.main(title: "Go to Finder",
                                                         backgroundColor: .lBlack)
        let unblurButton = LikesFactory.Buttons.plain(title: "Unblur all likes")
        
        
        self.addSubview(goToFinderButton)
        self.addSubview(unblurButton)
        goToFinderButton.translatesAutoresizingMaskIntoConstraints = false
        unblurButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goToFinderButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            goToFinderButton.topAnchor.constraint(equalTo: labelsHStack.bottomAnchor, constant: 24),
            goToFinderButton.heightAnchor.constraint(equalToConstant: 48),
          
            unblurButton.topAnchor.constraint(equalTo: goToFinderButton.bottomAnchor, constant: 8),
            unblurButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            unblurButton.heightAnchor.constraint(equalToConstant: 48),
            unblurButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 96)
        ])
        
        goToFinderButton.addTarget(self, action: #selector(goToFinderTapped), for: .touchUpInside)
        unblurButton.addTarget(self, action: #selector(onUnblurTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions -
    @objc private func goToFinderTapped() {
        self.onGoToFinderTap()
    }
    
    @objc private func onUnblurTapped() {
        self.onUnblurTap()
        self.removeFromSuperview()
    }
}
