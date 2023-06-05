import AdaptiveCards_bridge
import AppKit

class ACRMultilineInputTextView: NSView {
    private let renderConfig: RenderConfig
    private let element: ACSTextInput
    private let hostConfig: ACSHostConfig
    private weak var rootview: ACRView?
    // AccessibleFocusView property
    weak var exitView: AccessibleFocusView?
    
    private (set) lazy var multiLineTextView: ACRMultilineTextView = {
        let textView = ACRMultilineTextView(config: renderConfig, inputElement: element)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightType = element.getHeight()
        textView.setId(element.getId())
        if let placeholderString = element.getPlaceholder() {
            textView.setPlaceholder(placeholderString)
        }
        if let valueString = element.getValue(), !valueString.isEmpty {
            textView.setValue(value: valueString, maximumLen: element.getMaxLength())
        }
        textView.maxLen = element.getMaxLength() as? Int ?? 0
        textView.regex = element.getRegex()
        textView.isRequired = element.getIsRequired()
        return textView
    }()
    
    private (set) lazy var inlineButton: ACRButton = {
        let button = ACRButton(actionElement: element.getInlineAction(), iconPlacement: hostConfig.getActions()?.iconPlacement, buttonConfig: renderConfig.buttonConfig, style: .inline)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var inlineButtonTitle: String {
        return inlineButton.title
    }
    
    var inlineButtonAttributedTitle: NSAttributedString {
        get {
            return inlineButton.attributedTitle
        }
        set {
            inlineButton.attributedTitle = newValue
        }
    }
    
    init(renderConfig: RenderConfig, element: ACSTextInput, with hostConfig: ACSHostConfig, rootview: ACRView?) {
        self.renderConfig = renderConfig
        self.element = element
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
        self.addSubview(multiLineTextView)
        self.rootview?.addInputHandler(multiLineTextView)
        if element.getInlineAction() != nil {
            self.addSubview(inlineButton)
            self.setupInlineButton()
        }
    }
    
    private func setupContraints() {
        // multiline text view
        multiLineTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        multiLineTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        multiLineTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        if element.getInlineAction() != nil {
            inlineButton.leadingAnchor.constraint(equalTo: multiLineTextView.trailingAnchor, constant: 8.0).isActive = true
            if element.getHeight() == .auto {
                inlineButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            } else {
                inlineButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            }
            inlineButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            inlineButton.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5).isActive = true
        } else {
            multiLineTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    private func setupInlineButton() {
        guard let action = element.getInlineAction() else {
            return logError("InlineAction is nil")
        }
        guard let rootview = self.rootview else {
            return logError("MultiLine TextView InlineAction needs rootview")
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
}
extension ACRMultilineInputTextView: InputHandlingViewProtocol {
    var isErrorShown: Bool {
        return self.multiLineTextView.isErrorShown
    }
    
    var value: String {
        return self.multiLineTextView.value
    }
    
    var key: String {
        return self.multiLineTextView.key
    }
    
    var isValid: Bool {
        return self.multiLineTextView.isValid
    }
    
    var isRequired: Bool {
        return self.multiLineTextView.isRequired
    }
    
    weak var errorDelegate: InputHandlingViewErrorDelegate? {
        get {
            return self.multiLineTextView.errorDelegate
        }
        set {
            self.multiLineTextView.errorDelegate = newValue
        }
    }
    
    func showError() {
        self.multiLineTextView.showError()
    }
    
    func setAccessibilityFocus() {
        self.multiLineTextView.setAccessibilityFocus()
    }
}

extension ACRMultilineInputTextView: AccessibleFocusView {
    var validKeyView: NSView? {
        return self.multiLineTextView.textView
    }
    
    func setupInternalKeyviews() {
        if element.getInlineAction() != nil {
            self.multiLineTextView.textView.nextKeyView = self.inlineButton
            self.inlineButton.nextKeyView = self.exitView?.validKeyView
        } else {
            self.multiLineTextView.textView.nextKeyView = self.exitView?.validKeyView
        }
    }
}
