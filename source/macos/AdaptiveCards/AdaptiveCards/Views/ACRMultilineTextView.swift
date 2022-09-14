import AdaptiveCards_bridge
import AppKit

class ACRMultilineTextView: NSView, NSTextViewDelegate {
    @IBOutlet var scrollView: ACRScrollView!
    @IBOutlet var textView: ACRTextView!
    
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    private var placeholderAttrString: NSAttributedString?
    private var shouldShowError = false
    private var errorMessage: String?
    private var labelString: String?
    private let config: RenderConfig
    private let inputConfig: InputFieldConfig
    private var heightConstraint: NSLayoutConstraint?
    
    var maxLen = 0
    var id: String?
    var regex: String?
    var isRequired = false
    
    var heightType: ACSHeightType = .auto {
        didSet {
            setHeight()
        }
    }
    
    private init(config: RenderConfig) {
        self.config = config
        self.inputConfig = config.inputFieldConfig
        super.init(frame: .zero)
        BundleUtils.loadNibNamed("ACRMultilineTextView", owner: self)
        setupViews()
        setupConstraints()
    }
    
    convenience init(config: RenderConfig, inputElement: ACSBaseInputElement) {
        self.init(config: config)
        setupInputElementProperties(inputElement: inputElement)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scrollView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        setHeight()
    }
    
    private func setHeight() {
        if let heightConstraint = heightConstraint {
            NSLayoutConstraint.deactivate([heightConstraint])
        }
        if heightType == .auto {
            heightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 100)
        } else if heightType == .stretch {
            heightConstraint = scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        }
        if let heightConstraint = heightConstraint {
            NSLayoutConstraint.activate([heightConstraint])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.wantsLayer = true
        scrollView.focusRingCornerRadius = inputConfig.focusRingCornerRadius
        scrollView.focusRingType = .exterior
        scrollView.autohidesScrollers = true
        scrollView.disableScroll = true
        textView.delegate = self
        textView.responderDelegate = self
        textView.allowsUndo = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.smartInsertDeleteEnabled = false
        textView.font = inputConfig.font
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainerInset = NSSize(width: inputConfig.multilineFieldInsets.left, height: inputConfig.multilineFieldInsets.top)
        wantsLayer = true
        layer?.borderWidth = inputConfig.borderWidth
        layer?.cornerRadius = inputConfig.focusRingCornerRadius
        textView.setAccessibilityRoleDescription(config.localisedStringConfig.inputTextFieldAccessibilityTitle)
        
        // For hover need tracking area
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        updateAppearance()
    }
    
    override func accessibilityLabel() -> String? {
        guard config.supportsSchemeV1_3 else { return super.accessibilityTitle() }
        
        var accessibilityLabel = ""
        if shouldShowError {
            accessibilityLabel += config.localisedStringConfig.errorMessagePrefixString
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                accessibilityLabel += accessibilityLabel.isEmpty ? "" : ", "
                accessibilityLabel += errorMessage
            }
        }
        if let label = labelString, !label.isEmpty {
            accessibilityLabel += accessibilityLabel.isEmpty ? "" : ", "
            accessibilityLabel += label
        }
        if !textView.string.isEmpty {
            accessibilityLabel += accessibilityLabel.isEmpty ? "" : ", "
            accessibilityLabel += textView.string
        } else if let placeholder = placeholderAttrString?.string, !placeholder.isEmpty {
            accessibilityLabel += accessibilityLabel.isEmpty ? "" : ", "
            accessibilityLabel += placeholder
        }
        
        return accessibilityLabel
    }
    
    func setPlaceholder(_ placeholder: String) {
        let placeholderValue = NSMutableAttributedString(string: placeholder)
        placeholderValue.addAttributes([.foregroundColor: inputConfig.placeholderTextColor, .font: inputConfig.font], range: NSRange(location: 0, length: placeholderValue.length))
        textView.placeholderLeftPadding = inputConfig.multilineFieldInsets.left
        textView.placeholderTopPadding = inputConfig.multilineFieldInsets.top
        textView.placeholderAttrString = placeholderValue
        guard !config.supportsSchemeV1_3 else { return }
        textView.setAccessibilityPlaceholderValue(placeholder)
    }
    
    func setValue(value: String, maximumLen: NSNumber?) {
        var attributedValue = NSMutableAttributedString(string: value)
        let maxCharLen = Int(truncating: maximumLen ?? 0)
        if maxCharLen > 0, attributedValue.string.count > maxCharLen {
            attributedValue = NSMutableAttributedString(string: String(attributedValue.string.dropLast(attributedValue.string.count - maxCharLen)))
        }
        attributedValue.addAttributes([.foregroundColor: NSColor.textColor, .font: inputConfig.font], range: NSRange(location: 0, length: attributedValue.length))
        textView.textStorage?.setAttributedString(attributedValue)
    }
    
    func setId(_ idString: String?) {
        self.id = idString
    }
    
    func setVisibilty(to isVisible: Bool) {
        self.isHidden = !isVisible
    }
    
    func textDidChange(_ notification: Notification) {
        hideErrorIfNeeded()
        guard maxLen > 0  else { return } // maxLen returns 0 if propery not set
        // This stops the user from exceeding the maxLength property of Inut.Text if prroperty was set
        guard let textView = notification.object as? NSTextView, textView.string.count > maxLen else { return }
        textView.string = String(textView.string.dropLast())
        // Below check added to ensure prefilled value doesn't exceede the maxLength property if set
        if textView.string.count > maxLen {
            textView.string = String(textView.string.dropLast(textView.string.count - maxLen))
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        updateAppearance()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        updateAppearance()
    }
    
    private func hideErrorIfNeeded() {
        guard isValid else { return }
        shouldShowError = false
        errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: self)
        updateAppearance()
    }
    
    private func updateAppearance(hasFocus: Bool = false) {
        if shouldShowError {
            layer?.borderColor = inputConfig.errorStateConfig.borderColor.cgColor
            textView.backgroundColor = inputConfig.errorStateConfig.backgroundColor
        } else {
            layer?.borderColor = hasFocus ? inputConfig.activeBorderColor.cgColor : inputConfig.borderColor.cgColor
            textView.backgroundColor = isMouseInView ? inputConfig.highlightedColor : inputConfig.backgroundColor
        }
        updateAccessibilityVoiceOverMessage()
    }
    
    private func setupInputElementProperties(inputElement: ACSBaseInputElement) {
        guard config.supportsSchemeV1_3 else { return }
        labelString = inputElement.getLabel()
        errorMessage = inputElement.getErrorMessage()
        setAccessibilityPlaceholderValue(nil)
        updateAccessibilityVoiceOverMessage()
    }
    
    private func updateAccessibilityVoiceOverMessage() {
        textView.setAccessibilityTitle(accessibilityLabel())
    }
}

extension ACRMultilineTextView: InputHandlingViewProtocol {
    var value: String {
        textView.string
    }
    
    var key: String {
        guard let id = id else {
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
    
    func showError() {
        shouldShowError = true
        errorDelegate?.inputHandlingViewShouldShowError(self)
        updateAppearance()
    }
    
    func setAccessibilityFocus() {
        textView.setAccessibilityFocused(true)
        textView.selectAll(nil)
        errorDelegate?.inputHandlingViewShouldAnnounceErrorMessage(self, message: accessibilityLabel())
    }
}

extension ACRMultilineTextView: ACRTextViewResponderDelegate {
    func textViewDidBecomeFirstResponder() {
        scrollView.disableScroll = false
        updateAppearance(hasFocus: true)
    }
    
    func textViewDidResignFirstResponder() {
        scrollView.disableScroll = true
        updateAppearance()
    }
}
