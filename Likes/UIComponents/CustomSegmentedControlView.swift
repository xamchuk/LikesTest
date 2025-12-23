//
//  CustomSegmentedControlView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import UIKit

final class CustomSegmentedControlView: UIView {
    
    // MARK: - Views -
    private lazy var leftItemView = CustomSegmentedItemView(title: "Liked you") { [weak self] in
        self?.setActive(isLeft: true)
        self?.onIndex(0)
    }
    
    private lazy var rightItemView = CustomSegmentedItemView(title: "Likes sent") { [weak self] in
        self?.setActive(isLeft: false)
        self?.onIndex(1)
    }
    
    private let progressLineView = UIView()
    
    // MARK: - Constraints -
    private var lineCenterXAnchor: NSLayoutConstraint!
    
    
    // MARK: - Properties -
    private let onIndex: (Int) -> Void
    
    // MARK: - Init -
    init(onIndex: @escaping (Int) -> Void) {
        self.onIndex = onIndex
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    private func setup() {
        self.backgroundColor( .lWhite)
        let hStack = UIStackView(arrangedSubviews: [leftItemView, rightItemView])
            .axis(.horizontal)
            .spacing(16)
            .distribution(.fillEqually)
        
        hStack.addAndFill(self, edges: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        leftItemView.setBadge("2")
        rightItemView.setBadge(nil)
        
        let bottomLine = UIView()
            .backgroundColor(.lGreyLight)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLine)
        
        
        progressLineView
            .backgroundColor(.lBlack)
            .corner(2)
        
        progressLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        progressLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressLineView)
        
        NSLayoutConstraint.activate([
            // progressLineView
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            
            // progressLineView
            progressLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            progressLineView.heightAnchor.constraint(equalToConstant: 2),
            progressLineView.widthAnchor.constraint(equalTo: leftItemView.widthAnchor)
        ])
        
        lineCenterXAnchor = progressLineView.centerXAnchor.constraint(equalTo: leftItemView.centerXAnchor)
        lineCenterXAnchor.isActive = true
    }
    
    // MARK: - Public -
    func setActive(isLeft: Bool) {
        if isLeft {
            rightItemView.set(isActive: false)
            leftItemView.set(isActive: true)
        } else {
            rightItemView.set(isActive: true)
            leftItemView.set(isActive: false)
        }
        
        lineCenterXAnchor.isActive = false
        
        lineCenterXAnchor = progressLineView.centerXAnchor.constraint(
            equalTo: isLeft ? leftItemView.centerXAnchor : rightItemView.centerXAnchor
        )
        lineCenterXAnchor.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
        }
    }
}
