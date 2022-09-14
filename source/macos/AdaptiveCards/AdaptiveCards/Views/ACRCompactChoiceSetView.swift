//
//  ACRCompactChoiceSetView.swift
//  AdaptiveCards
//
//  Created by uchauhan on 13/09/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRCompactChoiceSetView: NSView {
    private let renderConfig: RenderConfig
    private let element: ACSChoiceSetInput
    private let style: ACSContainerStyle
    private let hostConfig: ACSHostConfig
    private let rootview: ACRView
    
    private lazy var contentStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.spacing = 0
        view.alignment = .leading
        // We add 1 digit edged insets because the external placeholder border of NSPopupButton is clipped when added in to nsstackview.
        view.edgeInsets = .init(top: 1, left: 1, bottom: 1, right: 1)
        return view
    }()
    
    private (set) lazy var choiceSetPopup: ACRChoiceSetCompactPopupButton = {
        let view = ACRChoiceSetCompactPopupButton(element: element, renderConfig: renderConfig)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoenablesItems = false
        view.idString = element.getId()
        view.isRequired = element.getIsRequired()
        view.setAccessibilityRoleDescription(renderConfig.localisedStringConfig.choiceSetCompactAccessibilityRoleDescriptor)
        return view
    }()
    
    var getArrangedSubviews: [NSView] {
        return contentStackView.arrangedSubviews
    }
    
    init(renderConfig: RenderConfig, element: ACSChoiceSetInput, style: ACSContainerStyle, with hostConfig: ACSHostConfig, rootview: ACRView) {
        self.renderConfig = renderConfig
        self.element = element
        self.style = style
        self.hostConfig = hostConfig
        self.rootview = rootview
        super.init(frame: .zero)
        self.setupView()
        self.setupContraints()
        self.rootview.addInputHandler(choiceSetPopup)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(choiceSetPopup)
        populateChoiceSet()
        setStretchableHeight()
    }
    
    private func setupContraints() {
        contentStackView.constraint(toFill: self)
        // stretch popup button to horizonatally
        choiceSetPopup.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
    }
    
    private func populateChoiceSet() {
        var index = 0
        if let placeholder = element.getPlaceholder(), !placeholder.isEmpty {
            choiceSetPopup.addItem(withTitle: placeholder)
            if let menuItem = choiceSetPopup.item(at: 0) {
                menuItem.isEnabled = false
            }
            choiceSetPopup.arrayValues.append(nil)
            index += 1
        }
        for choice in element.getChoices() {
            let title = choice.getTitle() ?? ""
            choiceSetPopup.addItem(withTitle: "")
            let item = choiceSetPopup.item(at: index)
            item?.title = title
            // item?.attributedTitle = getAttributedString(title: title, with: hostConfig, style: style, wrap: choiceSetInput.getWrap())
            choiceSetPopup.arrayValues.append(choice.getValue())
            if element.getValue() == choice.getValue() {
                choiceSetPopup.select(item)
                choiceSetPopup.valueSelected = choice.getValue()
            }
            index += 1
        }
    }
    
    private func setStretchableHeight() {
        if element.getHeight() == .stretch {
            let padding = StretchableView()
            ACSFillerSpaceManager.configureHugging(view: padding)
            contentStackView.addArrangedSubview(padding)
        }
    }
    
    override func accessibilityValue() -> Any? {
        return choiceSetPopup.accessibilityValue()
    }
}
extension ACRCompactChoiceSetView: InputHandlingViewProtocol {
    var value: String {
        return choiceSetPopup.value
    }
    
    var key: String {
        return choiceSetPopup.key
    }
    
    var isValid: Bool {
        return choiceSetPopup.isValid
    }
    
    var isRequired: Bool {
        return choiceSetPopup.isRequired
    }
    
    var errorDelegate: InputHandlingViewErrorDelegate? {
        get {
            return choiceSetPopup.errorDelegate
        }
        set {
            choiceSetPopup.errorDelegate = newValue
        }
    }
    
    var isErrorShown: Bool {
        return self.choiceSetPopup.isErrorShown
    }
    
    func showError() {
        choiceSetPopup.showError()
    }
    
    func setAccessibilityFocus() {
        choiceSetPopup.setAccessibilityFocus()
    }
}
