//
//  LikesFactory.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

struct LikesFactory {
    struct Labels {
        static func h1(size: CGFloat = 34) -> UILabel {
            let label = UILabel()
            label.font = UIFont.bagosBold(size: 34)
            label.textColor = .lBlack
            return label
        }
        
        static func b2Medium(size: CGFloat = 15, color: UIColor = .lBlack) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: size,
                                           weight: .medium)
            label.textColor = color
            return label
        }
        
        static func b2Regular(size: CGFloat = 15) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: size,
                                           weight: .regular)
            label.textColor = .lBlack
            return label
        }
        
        static func b2Bold(size: CGFloat = 15, color: UIColor = .lBlack) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: size,
                                           weight: .bold)
            label.textColor = color
            return label
        }
    }
    
    struct Buttons {
        static func circle(image: UIImage, backgroundColor: UIColor, size: CGFloat) -> UIButton {
            let button = UIButton(type: .system)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: size),
                button.widthAnchor.constraint(equalToConstant: size)
            ])

            var config = UIButton.Configuration.plain()
            config.image = image
            config.background.backgroundColor = backgroundColor
            config.background.cornerRadius = size / 2
           
            button.configuration = config

            return button
        }
        
        static func main(title: String, backgroundColor: UIColor) -> UIButton {
            var config = UIButton.Configuration.plain()
            // Font
            config.attributedTitle = AttributedString(
                title,
                attributes: AttributeContainer([
                    .font: UIFont.systemFont(ofSize: 15, weight: .bold),
                ])
            )
        
            config.background.backgroundColor = backgroundColor
            config.background.cornerRadius = 16
            config.baseForegroundColor = .lWhite
            config.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                           leading: 20,
                                                           bottom: 0,
                                                           trailing: 20)
            let button = UIButton(configuration: config)
            return button
        }
        
        static func plain(title: String) -> UIButton {
            var config = UIButton.Configuration.plain()
            // Font
            config.attributedTitle = AttributedString(
                title,
                attributes: AttributeContainer([
                    .font: UIFont.systemFont(ofSize: 15, weight: .bold),
                ])
            )
            config.background.backgroundColor = .clear
            config.baseForegroundColor = .lBlack
            config.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                           leading: 8,
                                                           bottom: 0,
                                                           trailing: 8)
            let button = UIButton(configuration: config)
            button.configuration = config
            return button
        }
    }
}
