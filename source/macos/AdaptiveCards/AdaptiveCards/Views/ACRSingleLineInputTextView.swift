//
//  ACRSingleLineInputTextView.swift
//  AdaptiveCards
//
//  Created by uchauhan on 12/09/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRSingleLineInputTextView: NSView {
    private let renderConfig: RenderConfig
    private let element: ACSTextInput
    private let style: ACSContainerStyle
    private let hostConfig: ACSHostConfig
    private weak var rootview: ACRView?
    // AccessibleFocusView property
    weak var exitView: AccessibleFocusView?
    
    private var contentView = NSView()
    private (set) lazy var contentStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.spacing = 0
        view.alignment = .leading
        return view
    }()
    
    private (set) lazy var textView: ACRTextInputView = {
        let textView = ACRTextInputView(textFieldWith: renderConfig, mode: .text, inputElement: element)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        // Makes text remain in 1 line
        textView.cell?.usesSingleLineMode = true
        textView.maximumNumberOfLines = 1
        // Make text scroll horizontally
        textView.cell?.isScrollable = true
        textView.cell?.truncatesLastVisibleLine = true
        textView.cell?.lineBreakMode = .byTruncatingTail
        textView.idString = element.getId()
        textView.regex = element.getRegex()
        textView.isRequired = element.getIsRequired()
        textView.setAccessibilityRoleDescription(renderConfig.localisedStringConfig.inputTextFieldAccessibilityTitle)
        if let maxLen = element.getMaxLength(), Int(truncating: maxLen) > 0 {
            textView.maxLen = Int(truncating: maxLen)
        }
        // Create placeholder and initial value string if they exist
        if let placeholderString = element.getPlaceholder() {
            textView.placeholderString = placeholderString
        }
        var attributedInitialValue: NSMutableAttributedString
        if let valueString = element.getValue() {
            attributedInitialValue = NSMutableAttributedString(string: valueString)
            if let maxLen = element.getMaxLength(), Int(truncating: maxLen) > 0, attributedInitialValue.string.count > Int(truncating: maxLen) {
                attributedInitialValue = NSMutableAttributedString(string: String(attributedInitialValue.string.dropLast(attributedInitialValue.string.count - Int(truncating: maxLen))))
            }
            textView.attributedStringValue = attributedInitialValue
        }
        return textView
    }()
    
    private (set) lazy var inlineButton: ACRButton = {
        let button = ACRButton(actionElement: element.getInlineAction(), iconPlacement: hostConfig.getActions()?.iconPlacement, buttonConfig: renderConfig.buttonConfig, style: .inline)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString: NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: button.title.isEmpty ? "" : button.title)
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        button.attributedTitle = attributedString
        return button
    }()
    
    init(renderConfig: RenderConfig, element: ACSTextInput, style: ACSContainerStyle, with hostConfig: ACSHostConfig, rootview: ACRView?) {
        self.renderConfig = renderConfig
        self.element = element
        self.style = style
        self.hostConfig = hostConfig
        super.init(frame: .zero)
        self.rootview = rootview
        self.setupView()
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(contentStackView)
        self.contentStackView.addArrangedSubview(contentView)
        self.contentView.addSubview(textView)
        self.rootview?.addInputHandler(self)
        if element.getInlineAction() != nil {
            self.contentView.addSubview(inlineButton)
            self.setupInlineButton()
        }
        if element.getHeight() == .stretch {
            self.setStretchableHeight()
        }
    }
    
    private func setupContraints() {
        contentStackView.constraint(toFill: self)
        // single line text view
        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        if element.getInlineAction() != nil {
            inlineButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 8.0).isActive = true
            inlineButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            inlineButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            inlineButton.widthAnchor.constraint(lessThanOrEqualTo: textView.widthAnchor, multiplier: 0.5).isActive = true
        } else {
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
    }
    
    private func setupInlineButton() {
        guard let action = element.getInlineAction() else {
            return logError("InlineAction is nil")
        }
        guard let rootview = self.rootview else {
            return logError("SingleLine TextView InlineAction needs rootview")
        }
        if let iconUrl = action.getIconUrl(), !iconUrl.isEmpty {
            rootview.registerImageHandlingView(inlineButton, for: iconUrl)
        }
        // adding target to the Buttons
        switch action.getType() {
        case .openUrl:
            guard let openURLAction = action as? ACSOpenUrlAction else {
                logError("Element is not of type ACSOpenUrlAction")
                return
            }
            let target = ActionOpenURLTarget(element: openURLAction, delegate: rootview)
            target.configureAction(for: inlineButton)
            rootview.addTarget(target)
        case .submit:
            guard let submitAction = action as? ACSSubmitAction else {
                logError("Element is not of type ACSSubmitAction")
                return
            }
            let target = ActionSubmitTarget(element: submitAction, delegate: rootview)
            target.configureAction(for: inlineButton)
            rootview.addTarget(target)
        default:
            break
        }
    }
    
    private func setStretchableHeight() {
        let padding = StretchableView()
        ACSFillerSpaceManager.configureHugging(view: padding)
        self.contentStackView.addArrangedSubview(padding)
    }
}
extension ACRSingleLineInputTextView: InputHandlingViewProtocol {
    weak var errorDelegate: InputHandlingViewErrorDelegate? {
        get {
            return self.textView.errorDelegate
        }
        set {
            self.textView.errorDelegate = newValue
        }
    }
    
    var isErrorShown: Bool {
        return self.textView.isErrorShown
    }
    
    var value: String {
        return self.textView.value
    }
    
    var key: String {
        return self.textView.key
    }
    
    var isValid: Bool {
        return self.textView.isValid
    }
    
    var isRequired: Bool {
        return self.textView.isRequired
    }
    
    func showError() {
        self.textView.showError()
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        self.textView.setAccessibilityFocus()
    }
}

extension ACRSingleLineInputTextView: AccessibleFocusView {
    var validKeyView: NSView? {
        return self.textView
    }
    
    func setupInternalKeyviews() {
        if element.getInlineAction() != nil {
            self.textView.exitView = self.inlineButton
            self.textView.setupInternalKeyviews()
            self.inlineButton.nextKeyView = exitView?.validKeyView
        } else {
            self.textView.exitView = exitView?.validKeyView
            self.textView.setupInternalKeyviews()
        }
    }
}
