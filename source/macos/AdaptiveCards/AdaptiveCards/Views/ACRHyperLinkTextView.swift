//
//  ACRHyperLinkTextView.swift
//  AdaptiveCards
//  This class is inherited from NSTextView.
//  This class is used to display a MarkDown Hyperlink in ACRChoiceButton.
//  Created by uchauhan on 30/05/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRHyperLinkTextView: NSTextView {
    private var clickOnLink = false
    
    // This override method keeps the textView Content size consistent with the text length.
    
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            return super.intrinsicContentSize
        }
        layoutManager.ensureLayout(for: textContainer)
        let size = layoutManager.usedRect(for: textContainer).size
        let width = size.width + 2
        return NSSize(width: width, height: size.height)
    }
    
    // This method set boolen True When user click on the hyperlink in the text.
    
    override func clicked(onLink link: Any, at charIndex: Int) {
        super.clicked(onLink: link, at: charIndex)
        clickOnLink = true
    }
    
    // When user perform mouse down, this override method calls the hyperlink if the boolen is True; otherwise, it calls the super class mouseDown.
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if !clickOnLink {
            superview?.mouseDown(with: event)
        } else {
            clickOnLink = false
        }
    }
}
