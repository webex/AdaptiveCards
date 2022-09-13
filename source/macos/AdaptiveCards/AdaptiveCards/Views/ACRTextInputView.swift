//
//  ACRTextInputView.swift
//  AdaptiveCards
//
//  Created by uchauhan on 13/09/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRTextInputView: ACRTextField, InputHandlingViewProtocol {
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    
    var value: String {
        return stringValue
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        guard isBasicValidationsSatisfied else { return false }
        guard !value.isEmpty, let regexVal = regex, !regexVal.isEmpty else { return true }
        return value.range(of: regexVal, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isRequired = false
    var maxLen: Int = 0
    var idString: String?
    var regex: String?
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        if isValid {
            errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: self)
            hideError()
        }
        
        guard maxLen > 0  else { return } // maxLen returns 0 if propery not set
        // This stops the user from exceeding the maxLength property of Input.Text if property was set
        guard let textView = notification.object as? NSTextView, textView.string.count > maxLen else { return }
        textView.string = String(textView.string.dropLast())
        // Below check added to ensure prefilled value doesn't exceede the maxLength property if set
        if textView.string.count > maxLen {
            textView.string = String(textView.string.dropLast(textView.string.count - maxLen))
        }
    }
    
    override func showError() {
        super.showError()
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        setAccessibilityFocused(true)
        errorDelegate?.inputHandlingViewShouldAnnounceErrorMessage(self, message: accessibilityTitle())
    }
}
