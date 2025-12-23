//
//  File.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import UIKit.UILabel

extension UILabel {
    
    // MARK: - Functions -
    func set(text: String, kernPercent: CGFloat) {
        guard let font = self.font else {
            self.text = text
            return
        }
        
        let kern = font.pointSize * (kernPercent / 2) / 100
        
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(
            .kern,
            value: kern,
            range: NSRange(location: 0, length: attributed.length)
        )
        
        self.attributedText = attributed
    }
    
    @discardableResult
    func set(text: String, kernPx: CGFloat) -> Self {
        guard let font = font else {
            self.text = text
            return self
        }
        
        // If spacing is zero → keep native kerning
        guard kernPx != 0 else {
            self.text = text
            return self
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor ?? .label,
            .kern: kernPx   // px ≈ pt
        ]
        
        attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return self
    }
    
    @discardableResult
    func lineHeight(_ height: Double) -> Self {
        let targetLineHeight = CGFloat(height)
        
        // Get attributed text or build from plain
        let result: NSMutableAttributedString
        if let a = attributedText, a.length > 0 {
            result = NSMutableAttributedString(attributedString: a)
        } else {
            let s = text ?? ""
            result = NSMutableAttributedString(string: s, attributes: [
                .font: font as Any,
                .foregroundColor: textColor as Any
            ])
        }
        
        guard result.length > 0 else { return self }
        let fullRange = NSRange(location: 0, length: result.length)
        
        // Paragraph style (keep existing if present)
        let style: NSMutableParagraphStyle = {
            if let existing = result.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                return existing.mutableCopy() as! NSMutableParagraphStyle
            }
            return NSMutableParagraphStyle()
        }()
        
        style.minimumLineHeight = targetLineHeight
        style.maximumLineHeight = targetLineHeight
        style.alignment = textAlignment
        
        result.addAttribute(.paragraphStyle, value: style, range: fullRange)
        
        // Apply baselineOffset per font run (important for mixed bold/regular)
        result.enumerateAttribute(.font, in: fullRange, options: []) { value, range, _ in
            let f = (value as? UIFont) ?? self.font ?? UIFont.systemFont(ofSize: 17)
            let offset = (targetLineHeight - f.lineHeight) / 2
            result.addAttribute(.baselineOffset, value: offset, range: range)
        }
        
        attributedText = result
        return self
    }
}
