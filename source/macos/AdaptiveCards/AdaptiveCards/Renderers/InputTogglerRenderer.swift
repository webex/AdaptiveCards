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
         guard let inputToggler = element as? ACSToggleInput else {
             logError("Element is not of type ACSToggleInput")
             return NSView()
         }
        print(inputToggler.getTitle(), "--")
        let inputToggleView = ACRInputTogglerView(checkboxWithTitle: inputToggler.getTitle() ?? "", target: nil, action: nil)
        inputToggleView.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString: NSMutableAttributedString
        return inputToggleView
     }
}

class ACRInputTogglerView: NSButton {
}
