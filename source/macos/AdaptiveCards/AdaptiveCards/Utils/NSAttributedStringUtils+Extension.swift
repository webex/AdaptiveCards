//
//  NSAttributedStringUtils+Extension.swift
//  AdaptiveCards
//
//  Created by uchauhan on 09/03/23.
//

import AppKit

extension NSTextAttachment {
    func setImageBounds(from font: NSFont) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        let pointHeight = font.pointSize + 2.0
        bounds = CGRect(x: bounds.origin.x, y: (font.capHeight - pointHeight).rounded() / 2, width: ratio * pointHeight, height: pointHeight)
    }
}
