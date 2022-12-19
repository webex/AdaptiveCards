//
//  ACRChoiceSetCompactPopupButton.swift
//  AdaptiveCards
//
//  Created by uchauhan on 13/09/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRChoiceSetCompactPopupButton: NSPopUpButton, InputHandlingViewProtocol {
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    
    public var idString: String?
    public var valueSelected: String?
    public var arrayValues: [String?] = []
    var isRequired = false
    
    public let type: ACSChoiceSetStyle = .compact
    
    private let renderConfig: RenderConfig
    private let label: String?
    private let errorMessage: String?
    private var shouldShowError = false
    
    init(element: ACSChoiceSetInput, renderConfig: RenderConfig) {
        self.renderConfig = renderConfig
        self.label = element.getLabel()
        self.errorMessage = element.getErrorMessage()
        super.init(frame: .zero, pullsDown: false)
        identifier = NSUserInterfaceItemIdentifier(rawValue: idString ?? "")
        target = self
        action = #selector(popUpButtonUsed(_:))
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRChoiceSetCompactPopupButton else { return }
        contentView.isHighlighted = true
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRChoiceSetCompactPopupButton else { return }
        contentView.isHighlighted = false
    }
    
    @objc private func popUpButtonUsed(_ sender: NSPopUpButton) {
        shouldShowError = false
        errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: self)
        setToolTip()
    }
    
    func showError() {
        shouldShowError = true
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        setAccessibilityFocused(true)
        errorDelegate?.inputHandlingViewShouldAnnounceErrorMessage(self, message: nil)
    }
    
    func setToolTip() {
        toolTip = itemArray[indexOfSelectedItem].title
    }
    
    var value: String {
        return arrayValues[indexOfSelectedItem] ?? ""
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isErrorShown: Bool {
        return shouldShowError
    }
    
    override func accessibilityValue() -> Any? {
        guard renderConfig.supportsSchemeV1_3 else {
            return itemArray[indexOfSelectedItem].title
        }
        var accessibilityLabel = ""
        if let errorDelegate = errorDelegate, errorDelegate.isErrorVisible(self) {
            accessibilityLabel += "Error "
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                accessibilityLabel += errorMessage + ", "
            }
        }
        if let label = label, !label.isEmpty {
            accessibilityLabel += label + ", "
        }
        accessibilityLabel += itemArray[indexOfSelectedItem].title
        return accessibilityLabel
    }
    
    var isValid: Bool {
        return isRequired ? (arrayValues[indexOfSelectedItem] != nil) : true
    }
}
