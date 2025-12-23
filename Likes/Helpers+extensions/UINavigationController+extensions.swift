//
//  UINavigationController+extensions.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

public extension UINavigationController {

    func setupForTab(image: UIImage?, selectedImage: UIImage?) {
        tabBarItem.image = image
        tabBarItem.selectedImage = selectedImage
    }
}
