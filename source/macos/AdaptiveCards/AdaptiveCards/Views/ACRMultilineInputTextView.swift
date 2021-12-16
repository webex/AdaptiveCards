import AdaptiveCards_bridge
import AppKit

class ACRMultilineInputTextView: NSView, NSTextViewDelegate {
    @IBOutlet var contentView: NSView!
    @IBOutlet var scrollView: ACRScrollView!
    @IBOutlet var textView: ACRTextView!
    
    private var placeholderAttrString: NSAttributedString?
    weak var errorMessageHandler: ErrorMessageHandlerDelegate?
    private let config: RenderConfig
    private let inputConfig: InputFieldConfig
    var maxLen = 0
    var id: String?
    var inputValidator = ACRInputTextValidator()
    var textFieldShowsError: Bool {
        return layer?.borderColor == inputConfig.errorMessageConfig.errorBorderColor?.cgColor || textView.backgroundColor == inputConfig.errorMessageConfig.errorBackgroundColor
    }
    var hasMouseInField = false
    
    init(config: RenderConfig) {
        self.config = config
        self.inputConfig = config.inputFieldConfig
        super.init(frame: .zero)
        BundleUtils.loadNibNamed("ACRMultilineInputTextView", owner: self)
        textView.allowsUndo = true
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        heightConstraint.isActive = true
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
        textView.setAccessibilityTitle(config.localisedStringConfig.inputTextFieldAccessibilityTitle)
        setupColors(hasFocus: false)
        
        // For hover need tracking area
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    func setPlaceholder(_ placeholder: String) {
        let placeholderValue = NSMutableAttributedString(string: placeholder)
        placeholderValue.addAttributes([.foregroundColor: inputConfig.placeholderTextColor, .font: inputConfig.font], range: NSRange(location: 0, length: placeholderValue.length))
        textView.placeholderLeftPadding = inputConfig.multilineFieldInsets.left
        textView.placeholderTopPadding = inputConfig.multilineFieldInsets.top
        textView.placeholderAttrString = placeholderValue
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
        if isValid && textFieldShowsError {
            ACRView.focusedElementOnHideError = textView
            errorMessageHandler?.hideErrorMessage(for: self)
            setupColors(hasFocus: true)
        }
        
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
        if !textFieldShowsError {
            textView.backgroundColor = inputConfig.highlightedColor
        }
        hasMouseInField = true
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if !textFieldShowsError {
            textView.backgroundColor = inputConfig.backgroundColor
        }
        hasMouseInField = false
    }
    
    private func setupColors(hasFocus: Bool) {
        layer?.borderColor = hasFocus ? inputConfig.activeBorderColor.cgColor : inputConfig.borderColor.cgColor
        textView.backgroundColor = hasMouseInField ? inputConfig.highlightedColor : inputConfig.backgroundColor
    }
    
    private func setupErrorColors() {
        guard let errorBorderColor = config.inputFieldConfig.errorMessageConfig.errorBorderColor, let errorBackgroundColor = config.inputFieldConfig.errorMessageConfig.errorBackgroundColor else { return }
        layer?.borderColor = errorBorderColor.cgColor
        textView.backgroundColor = errorBackgroundColor
    }
}

extension ACRMultilineInputTextView: InputHandlingViewProtocol {
    func showError() {
        errorMessageHandler?.showErrorMessage(for: self)
        setupErrorColors()
    }
    
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
        return inputValidator.getIsValid(for: textView.string)
    }
    
    var isRequired: Bool {
        get { return inputValidator.isRequired }
        set { inputValidator.isRequired = newValue }
    }
}

extension ACRMultilineInputTextView: ACRTextViewResponderDelegate {
    func textViewDidBecomeFirstResponder() {
        scrollView.disableScroll = false
        if !textFieldShowsError {
            setupColors(hasFocus: true)
        }
    }
    
    func textViewDidResignFirstResponder() {
        scrollView.disableScroll = true
        if !textFieldShowsError {
            setupColors(hasFocus: false)
        }
    }
}
