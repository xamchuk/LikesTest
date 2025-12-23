//
//  TimerItemView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import UIKit

final class TimerItemView: UIView {
    
    private let label = LikesFactory.Labels.b2Bold(size: 11, color: .lWhite)
    
    // MARK: - Init -
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    private func setup() {
        self.backgroundColor(.lWhite.withAlphaComponent(0.2))
            .corner(4)
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: 20),
            self.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        label.set(text: "00", kernPercent: -0.5)
    }
    
    // MARK: - Public -
    func set(text: String) {
        guard label.text != text else { return }
        
        UIView.transition(with: label, duration: 0.18, options: [.transitionCrossDissolve, .allowUserInteraction]) {
            self.label.set(text: text, kernPercent: -0.5)
        }
        
        label.layer.removeAnimation(forKey: "tick")
        let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.fromValue = 0.5
        anim.toValue = 1.0
        anim.duration = anim.settlingDuration
        anim.damping = 18
        anim.mass = 0.6
        anim.stiffness = 250
        anim.initialVelocity = 0
        label.layer.add(anim, forKey: "tick")
    }
}
