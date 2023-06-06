//
//  ACRInputToggleView.swift
//  AdaptiveCards
//
//  Created by uchauhan on 12/09/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRInputToggleView: NSView {
    private let renderConfig: RenderConfig
    private let element: ACSToggleInput
    
    var labelAttributedString: NSAttributedString {
        get {
            return choiceButton.labelAttributedString
        }
        set {
            choiceButton.labelAttributedString = newValue
        }
    }
    
    var state: NSControl.StateValue {
        get {
            return self.choiceButton.state
        }
        set {
            self.choiceButton.state = newValue
        }
    }
    
    private (set) lazy var contentStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.spacing = 0
        view.alignment = .leading
        return view
    }()
    
    private (set) lazy var choiceButton: ACRChoiceButton = {
        let view = ACRChoiceButton(renderConfig: renderConfig, buttonType: .switch, element: element)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(renderConfig: RenderConfig, element: ACSToggleInput) {
        self.renderConfig = renderConfig
        self.element = element
        super.init(frame: .zero)
        self.setupView()
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(contentStackView)
        self.contentStackView.addArrangedSubview(choiceButton)
        if element.getHeight() == .stretch {
            setStretchableHeight()
        }
    }
    
    private func setupContraints() {
        contentStackView.constraint(toFill: self)
    }
    
    private func setStretchableHeight() {
        let padding = StretchableView()
        ACSFillerSpaceManager.configureHugging(view: padding)
        self.contentStackView.addArrangedSubview(padding)
    }
    
    override func accessibilityLabel() -> String? {
        return choiceButton.accessibilityLabel()
    }
    
    override func accessibilityRole() -> NSAccessibility.Role? {
        return choiceButton.accessibilityRole()
    }
    
    override func accessibilityValue() -> Any? {
        return choiceButton.accessibilityValue
    }
}
extension ACRInputToggleView: InputHandlingViewProtocol {
    var value: String {
        return self.choiceButton.value
    }
    
    var key: String {
        return self.choiceButton.key
    }
    
    var isValid: Bool {
        return self.choiceButton.isValid
    }
    
    var isRequired: Bool {
        return self.choiceButton.isRequired
    }
    
    var errorDelegate: InputHandlingViewErrorDelegate? {
        get {
            return self.choiceButton.errorDelegate
        }
        set {
            self.choiceButton.errorDelegate = newValue
        }
    }
    
    var isErrorShown: Bool {
        return self.choiceButton.isErrorShown
    }
    
    func showError() {
        self.choiceButton.setShowError(true)
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        self.choiceButton.setAccessibilityFocus()
    }
}
