//
//  GradientView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import UIKit

final class GradientView: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 24
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }
}
