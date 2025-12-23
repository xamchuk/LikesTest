//
//  ImageCache.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//


import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let memory = NSCache<NSString, UIImage>()
    private let ioQueue = DispatchQueue(label: "ImageCache.io")

    private init() {
        memory.countLimit = 200 // tune if needed
    }

    // MARK: - Public

    func image(forKey key: String) -> UIImage? {
        if let img = memory.object(forKey: key as NSString) { return img }

        if let img = loadFromDisk(forKey: key) {
            memory.setObject(img, forKey: key as NSString)
            return img
        }

        return nil
    }

    func store(_ image: UIImage, forKey key: String) {
        memory.setObject(image, forKey: key as NSString)
        saveToDisk(image, forKey: key)
    }

    func remove(forKey key: String) {
        memory.removeObject(forKey: key as NSString)
        ioQueue.async {
            try? FileManager.default.removeItem(at: self.fileURL(forKey: key))
        }
    }

    // MARK: - Disk

    private func loadFromDisk(forKey key: String) -> UIImage? {
        let url = fileURL(forKey: key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func saveToDisk(_ image: UIImage, forKey key: String) {
        ioQueue.async {
            let url = self.fileURL(forKey: key)

            // Prefer PNG if has alpha, otherwise JPEG
            let data: Data?
            if imageHasAlpha(image) {
                data = image.pngData()
            } else {
                data = image.jpegData(compressionQuality: 0.92)
            }

            guard let data else { return }
            try? data.write(to: url, options: [.atomic])
        }
    }

    private func fileURL(forKey key: String) -> URL {
        let safeName = key.replacingOccurrences(of: "/", with: "_")
                          .replacingOccurrences(of: ":", with: "_")

        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("image_cache", isDirectory: true)

        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        return dir.appendingPathComponent(safeName).appendingPathExtension("img")
    }
}

private func imageHasAlpha(_ image: UIImage) -> Bool {
    guard let alpha = image.cgImage?.alphaInfo else { return false }
    switch alpha {
    case .first, .last, .premultipliedFirst, .premultipliedLast: return true
    default: return false
    }
}