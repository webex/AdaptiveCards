//
//  TextInputRenderer.swift
//  AdaptiveCards
//
//  Created by mukuagar on 11/02/21.
//

import AdaptiveCards_bridge
import AppKit

class TextInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = TextInputRenderer()
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let inputBlock = element as? ACSTextInput else {
            logError("Element is not of type ACSTextInput")
            return NSView()
        }
        let textView = ACRTextInputView()
        var attributedPlaceHolder: NSMutableAttributedString
        var attributedInitialValue: NSMutableAttributedString
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isBordered = true
        textView.isEditable = true
//        textView.delegate = self
        if let maxLen = inputBlock.getMaxLength() {
            if Int(truncating: maxLen) > 0 {
                textView.maxLen = Int(truncating: maxLen)
            }
        }
        if inputBlock.getIsMultiline() {
            // Disable Horizontal scrolling
            textView.cell?.isScrollable = false
            textView.cell?.wraps = true
            // Makes text go to next line
            textView.cell?.usesSingleLineMode = false
            } else {
            // Makes text remain in 1 line even when Ctrl + return pressed
            textView.cell?.usesSingleLineMode = true
            textView.maximumNumberOfLines = 1
            // Make text scroll horizontally
            textView.cell?.isScrollable = true
        }
        var doesPlaceholderExist = false
        var doesValueExist = false
        // Check if placeholder and initial value exist
        if inputBlock.getPlaceholder() != nil {
            doesPlaceholderExist = true
            }
        if inputBlock.getValue() != nil {
            doesValueExist = true
            }
        // Create placeholder and initial value string if they exist
        if doesPlaceholderExist {
            attributedPlaceHolder = NSMutableAttributedString(string: inputBlock.getPlaceholder() ?? "")
            if let colorHex = hostConfig.getForegroundColor(style, color: ACSForegroundColor.default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
                attributedPlaceHolder.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedPlaceHolder.length))
            }
            textView.placeholderAttributedString = attributedPlaceHolder
        }
        if doesValueExist {
            attributedInitialValue = NSMutableAttributedString(string: inputBlock.getValue() ?? "")
            
            textView.attributedStringValue = attributedInitialValue
            }
        return textView
    }
}

class ACRTextInputView: NSTextField, NSTextFieldDelegate {
    var maxLen: Int = 0
    override func textDidChange(_ notification: Notification) {
        if maxLen > 0 {
            guard let object = notification.object as? NSTextView else {
                return
            }
                if (object.string.count) > maxLen {
                    object.string = String(object.string.dropLast())
            }
        }
    }
}
