//
//  TimerView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import UIKit

final class TimerView: UIView {
    
    // MARK: - Views -
    private let hoursView = TimerItemView()
    private let minutesView = TimerItemView()
    private let secondsView = TimerItemView()
    
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
        self.backgroundColor(.lBlack)
            .corner(12)
        
        let titleLabel = LikesFactory.Labels.b2Bold(size: 14,
                                                    color: .lWhite)
        
        titleLabel.set(text: "Everyone unblurred for", kernPercent: -1)
        
        let timeHStack = UIStackView(arrangedSubviews: [
            hoursView,
            makeDotLabel(),
            minutesView,
            makeDotLabel(),
            secondsView,
        ]).axis(.horizontal)
            .alignment(.center)
            .spacing(2)
        
        let mainHStack = UIStackView(arrangedSubviews: [
            titleLabel,
            timeHStack
        ])
            .axis(.horizontal)
            .spacing(8)
            .alignment(.center)
        
        self.addSubview(mainHStack)
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainHStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            mainHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Private -
    private func makeDotLabel() -> UILabel {
        let label = LikesFactory.Labels.b2Bold(size: 11, color: .lWhite)
        label.textAlignment = .center
        label.set(text: ":", kernPercent: -0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        return label
    }
    
    // MARK: - Public -
    func set(hours: String, minutes: String, seconds: String) {
        hoursView.set(text: hours)
        minutesView.set(text: minutes)
        secondsView.set(text: seconds)
    }
}
