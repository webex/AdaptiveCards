//
//  InputTogglerRendere.swift
//  AdaptiveCards
//
//  Created by rohshar6 on 11/02/21.
//

import AdaptiveCards_bridge
import AppKit

class InputTogglerRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = InputTogglerRenderer()
     
     func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
         guard let inputToggle = element as? ACSToggleInput else {
             logError("Element is not of type ACSToggleInput")
             return NSView()
         }
        // NSMutableAttributedString for the checkbox title
        var attributedString: NSMutableAttributedString
        // NSButton for checkbox
        let inputToggleView = ACRInputToggleView(checkboxWithTitle: inputToggle.getTitle() ?? "", target: self, action: nil)
        inputToggleView.translatesAutoresizingMaskIntoConstraints = false
        // adding attributes to the string
        attributedString = NSMutableAttributedString(string: inputToggle.getTitle() ?? "")
        if let colorHex = hostConfig.getForegroundColor(style, color: ACSForegroundColor.default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        var defaultInputToggleStateValue: Int?
        if inputToggle.getValue() != inputToggle.getValueOn() {
            defaultInputToggleStateValue = 0
        } else {
            defaultInputToggleStateValue = 1
        }
        inputToggleView.state = NSControl.StateValue(rawValue: defaultInputToggleStateValue == 0 ? 0 : 1)
        inputToggleView.attributedTitle = attributedString
        // Wrap
        if inputToggle.getWrap() {
        }
        return inputToggleView
     }
}

class ACRInputToggleView: NSButton {
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
    }
}
