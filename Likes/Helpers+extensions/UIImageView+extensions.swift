//
//  UIImageView+extensions.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import UIKit

enum BundleImageLoader {
    static func load(named key: String) -> UIImage? {
        // If images are in Assets, this is enough:
        if let img = UIImage(named: key) { return img }

        // If you place raw files in bundle root (e.g. "photo_01.png"):
        // key might already include extension OR not.
        let parts = key.split(separator: ".", maxSplits: 1).map(String.init)

        if parts.count == 2 {
            return UIImage(contentsOfFile: Bundle.main.path(forResource: parts[0], ofType: parts[1]) ?? "")
        } else {
            // Try common extensions
            for ext in ["png", "jpg", "jpeg", "webp"] {
                if let path = Bundle.main.path(forResource: key, ofType: ext),
                   let img = UIImage(contentsOfFile: path) {
                    return img
                }
            }
            return nil
        }
    }
}

extension UIImageView {
    /// Loads image by mock "key"
    /// 1) memory cache
    /// 2) disk cache
    /// 3) bundle (mock server)
    /// then stores to disk+memory
    func setCachedImage(named key: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        // 1/2: cache
        if let img = ImageCache.shared.image(forKey: key) {
            self.image = img
            return
        }

        // 3: bundle (mock server)
        DispatchQueue.global(qos: .userInitiated).async {
            let img = BundleImageLoader.load(named: key)

            if let img {
                ImageCache.shared.store(img, forKey: key)
            }

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.image = img ?? placeholder
            }
        }
    }
}
