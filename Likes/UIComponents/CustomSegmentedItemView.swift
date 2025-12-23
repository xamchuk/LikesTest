//
//  CustomSegmentedItemView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import UIKit

final class CustomSegmentedItemView: UIControl {
    
    // MARK: - Views -
    private let titleLabel = LikesFactory.Labels.b2Medium(size: 15)
    private let badgeContainer = UIView()
    private let badgeLabel = LikesFactory.Labels.b2Medium(size: 12, color: .lWhite)
    
    // MARK: - Properties -
    private let onTap: () -> Void
    
    // MARK: - Init -
    init(title: String, onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        setup(title: title)
        setupHighlighting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    private func setup(title: String) {
        let hStack = UIStackView(arrangedSubviews: [
            titleLabel,
            badgeContainer,
        ])
            .spacing(8)
            .axis(.horizontal)
            .alignment(.center)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hStack)
        
        badgeContainer.backgroundColor(.lRed)
            .corner(9)
        
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeContainer.addSubview(badgeLabel)
        hStack.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            // badgeContainer
            badgeContainer.heightAnchor.constraint(equalToConstant: 18),
            badgeContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            // badgeLabel
            badgeLabel.topAnchor.constraint(equalTo: badgeContainer.topAnchor),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor, constant: 4),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor, constant: -4),
            badgeLabel.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            // hStack
            hStack.heightAnchor.constraint(equalToConstant: 48),
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            hStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
      
        titleLabel.set(text: title, kernPercent: -1.5)
        badgeLabel.textAlignment = .center
        badgeLabel.set(text: "2", kernPx: 0)
        
        isExclusiveTouch = true
        
        addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onTap()
            self.set(isActive: true)
        }, for: .touchUpInside)
    }
    
    // MARK: - Private -
    private func setupHighlighting() {
        // press down
        addAction(UIAction { [weak self] _ in
            self?.setPressed(true)
        }, for: .touchDown)
        
        // release / cancel / drag out
        let unpress: UIControl.Event = [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit]
        addAction(UIAction { [weak self] _ in
            self?.setPressed(false)
        }, for: unpress)
    }
    
    private func setPressed(_ pressed: Bool) {
        UIView.animate(withDuration: 0.12,
                       delay: 0,
                       options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.alpha = pressed ? 0.3 : 1.0
        }
    }
    
    // MARK: - Public -
    func setBadge(_ text: String?) {
        if let text, text != "" {
            badgeContainer.isHidden = false
            badgeLabel.set(text: text, kernPx: 0)
        } else {
            badgeContainer.isHidden = true
        }
    }
    
    func set(isActive: Bool) {
        titleLabel.textColor = isActive ? .lBlack : .lGrey.withAlphaComponent(0.63)
        badgeContainer.backgroundColor(isActive ? .lRed : .lGreyLight)
    }
}
