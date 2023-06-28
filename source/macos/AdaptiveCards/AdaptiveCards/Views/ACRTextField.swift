import AdaptiveCards_bridge
import AppKit

protocol ACRTextFieldDelegate: AnyObject {
    func acrTextFieldDidSelectClear(_ textField: ACRTextField)
}

class ACRTextField: NSTextField {
    public enum Mode {
        case text
        case dateTime
        case number
    }
    
    weak var textFieldDelegate: ACRTextFieldDelegate?
    private let config: RenderConfig
    private let inputConfig: InputFieldConfig
    private let inputElement: ACSBaseInputElement
    private let isDarkMode: Bool
    private let textFieldMode: Mode
    private var shouldShowError = false
    private var errorMessage: String?
    private var labelString: String?
    weak var exitView: NSView?
    weak var dateView: ACRDateField?
    
    init(textFieldWith config: RenderConfig, mode: Mode, inputElement: ACSBaseInputElement) {
        self.config = config
        self.inputConfig = config.inputFieldConfig
        self.inputElement = inputElement
        self.isDarkMode = config.isDarkMode
        textFieldMode = mode
        super.init(frame: .zero)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInputElementProperties() {
        guard config.supportsSchemeV1_3 else { return }
        labelString = inputElement.getLabel()
        errorMessage = inputElement.getErrorMessage()
        setAccessibilityPlaceholderValue(nil)
    }
    
    private func initialise() {
        let customCell = VerticallyCenteredTextFieldCell()
        customCell.drawsBackground = true
        customCell.backgroundColor = .clear
        // 20 points extra padding for calendar/clock icons
        var leftPadding: CGFloat = 0
        if textFieldMode == .dateTime {
            // 20 is image width and 12 is the spacing after image to text
            leftPadding += 32
            if inputConfig.clearButtonImage == nil {
                // Implies old date field, so clear button hugs edge
                leftPadding -= 12
            }
        } else {
            leftPadding += inputConfig.leftPadding
        }
        customCell.setupSpacing(rightPadding: inputConfig.rightPadding, leftPadding: leftPadding, yPadding: inputConfig.yPadding, focusRingCornerRadius: inputConfig.focusRingCornerRadius, wantsClearButton: wantsClearButton, isNumericField: textFieldMode == .number)
        cell = customCell
        font = inputConfig.font
        if wantsClearButton {
            addSubview(clearButton)
            clearButton.isHidden = true
        }
        // Add inintial backgound color to text box
        wantsLayer = true
        layer?.backgroundColor = inputConfig.backgroundColor.cgColor
        layer?.borderWidth = inputConfig.borderWidth
        
        setupConstraints()
        setupInputElementProperties()
        updateAppearance()
        setupTrackingArea()
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: inputConfig.height).isActive = true
        if wantsClearButton {
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inputConfig.rightPadding).isActive = true
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    private (set) lazy var clearButton: NSButtonWithImageSpacing = {
        let clearImage: NSImage?
        if inputConfig.clearButtonImage == nil, wantsClearButton {
            // displaying old clear button
            let resourceName = isDarkMode ? "clear_18_w" : "clear_18"
            clearImage = BundleUtils.getImage(resourceName, ofType: "png")
        } else {
            clearImage = inputConfig.clearButtonImage
        }
        let view = NSButtonWithImageSpacing(image: clearImage ?? NSImage(), target: self, action: #selector(handleClearAction))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.isBordered = false
        view.setAccessibilityElement(true)
        view.setAccessibilityRole(.button)
        view.setAccessibilityTitle(config.localisedStringConfig.clearButtonAccessibilityTitle)
        view.keyDownCall = { [weak self] _ in
            self?.handleClearAction()
        }
        return view
    }()
    
    private var isEmpty: Bool {
        return stringValue.isEmpty && attributedStringValue.string.isEmpty
    }
    
    override var placeholderString: String? {
        get { return placeholderAttributedString?.string }
        set {
            let placeholderAttrString = NSAttributedString(string: newValue ?? "")
            let range = NSRange(location: 0, length: placeholderAttrString.length )
            let attributedString = NSMutableAttributedString(attributedString: placeholderAttrString)
            attributedString.addAttributes([.foregroundColor: inputConfig.placeholderTextColor, .font: inputConfig.font], range: range)
            placeholderAttributedString = attributedString
        }
    }
    
    @objc private func handleClearAction() {
        self.stringValue = ""
        textFieldDelegate?.acrTextFieldDidSelectClear(self)
        updateClearButton()
    }
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        updateLastKnownCursorPosition()
        updateClearButton()
    }
    
    override var attributedStringValue: NSAttributedString {
        didSet {
            updateClearButton()
        }
    }
    
    override var stringValue: String {
        didSet {
            updateClearButton()
        }
    }
    
    override var doubleValue: Double {
        didSet {
            updateClearButton()
        }
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        updateAppearance()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        updateAppearance()
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        updateAppearance()
        return super.textDidEndEditing(notification)
    }
    
    override func drawFocusRingMask() {
        super.drawFocusRingMask()
        updateAppearance(hasFocus: true)
    }
    
    private func updateClearButton() {
        clearButton.isHidden = isEmpty
        self.setupInternalKeyviews()
    }
    
    private var wantsClearButton: Bool {
        return inputConfig.wantsClearButton || (textFieldMode == .dateTime)
    }
    
    override func becomeFirstResponder() -> Bool {
        let textView = window?.fieldEditor(true, for: nil) as? NSTextView
        textView?.insertionPointColor = isDarkMode ? .white : .black
        return super.becomeFirstResponder()
    }
    
    override func accessibilityChildren() -> [Any]? {
        if wantsClearButton && !clearButton.isHidden {
            var temp = super.accessibilityChildren()
            temp?.append(clearButton)
            return temp
        }
        return super.accessibilityChildren()
    }
    
    override func accessibilityTitle() -> String? {
        guard config.supportsSchemeV1_3 else { return super.accessibilityTitle() }
        
        var accessibilityTitle = ""
        if shouldShowError {
            accessibilityTitle += config.localisedStringConfig.errorMessagePrefixString
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                accessibilityTitle += accessibilityTitle.isEmpty ? "" : ", "
                accessibilityTitle += errorMessage
            }
        }
        if let label = labelString, !label.isEmpty {
            accessibilityTitle += accessibilityTitle.isEmpty ? "" : ", "
            accessibilityTitle += label
        }
        if !stringValue.isEmpty {
            accessibilityTitle += accessibilityTitle.isEmpty ? "" : ", "
            accessibilityTitle += stringValue
        } else if let placeholder = placeholderString, !placeholder.isEmpty {
            accessibilityTitle += accessibilityTitle.isEmpty ? "" : ", "
            accessibilityTitle += placeholder
        }
        
        return accessibilityTitle
    }
    
    private var lastCursorPosition: Int?
    private func updateLastKnownCursorPosition() {
        guard let selectedRange = currentEditor()?.selectedRange else {
            lastCursorPosition = nil
            return
        }
        lastCursorPosition = selectedRange.upperBound
    }
    
    func resetCursorPositionIfNeeded() {
        guard let cursorPosition = lastCursorPosition else { return }
        currentEditor()?.selectedRange = NSRange(location: cursorPosition, length: 0)
    }
    
    func showError() {
        shouldShowError = true
        updateAppearance()
    }
    
    func hideError() {
        shouldShowError = false
        updateAppearance()
    }
    
    func isErrorShown() -> Bool {
        return shouldShowError
    }
    
    private func updateAppearance(hasFocus: Bool = false) {
        let isActive = hasFocus && isSelectable
        if shouldShowError {
            layer?.borderColor = inputConfig.errorStateConfig.borderColor.cgColor
        } else {
            layer?.borderColor = isActive ? inputConfig.activeBorderColor.cgColor : inputConfig.borderColor.cgColor
            layer?.backgroundColor = isMouseInView ? inputConfig.highlightedColor.cgColor : inputConfig.backgroundColor.cgColor
        }
    }
}

extension ACRTextField {
    func setupInternalKeyviews() {
        if textFieldMode == .dateTime {
            // NOTE: We require a date view ref to set the next keyview. We make acrdateview to the keyview in dateinput.
            dateView?.nextKeyView = nil
            clearButton.nextKeyView = nil
            if !clearButton.isHidden {
                dateView?.nextKeyView = clearButton
                clearButton.nextKeyView = exitView
                return
            }
            dateView?.nextKeyView = exitView
        } else {
            self.nextKeyView = nil
            self.clearButton.nextKeyView = nil
            if self.wantsClearButton && !clearButton.isHidden {
                self.nextKeyView = self.clearButton
                self.clearButton.nextKeyView = exitView
                return
            }
            self.nextKeyView = exitView
        }
    }
}

class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    private struct Constants {
        static let rightPaddingWithClearButton: CGFloat = 20
    }
    private var rightPadding: CGFloat = 0
    private var leftPadding: CGFloat = 0
    private var yPadding: CGFloat = 0
    private var focusRingCornerRadius: CGFloat = 0
    private var wantsClearButton = false
    private var isNumericField = false
    
    func setupSpacing(rightPadding: CGFloat = 0, leftPadding: CGFloat = 0, yPadding: CGFloat = 0, focusRingCornerRadius: CGFloat = 0, wantsClearButton: Bool, isNumericField: Bool) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.yPadding = yPadding
        self.focusRingCornerRadius = focusRingCornerRadius
        self.wantsClearButton = wantsClearButton
        self.isNumericField = isNumericField
    }
    
    private func adjustedFrame(forBounds rect: NSRect) -> NSRect {
        var newRect = rect
        // Subtract yPadding to remove offset due to to font baseline
        let yoffset = floor((rect.height - ceil(font?.boundingRectForFont.size.height ?? 0)) / 2) - yPadding
        newRect.origin.y += yoffset
        newRect.origin.x += leftPadding
        if rect.size.width > 0 {
            newRect.size.width -= rightPadding + leftPadding + (wantsClearButton ? Constants.rightPaddingWithClearButton : 0)
        }
        return newRect
    }
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        return adjustedFrame(forBounds: rect)
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        super.drawInterior(withFrame: adjustedFrame(forBounds: cellFrame), in: controlView)
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        super.select(withFrame: adjustedFrame(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        let path = NSBezierPath()
        if isNumericField {
            path.move( to: CGPoint(x: cellFrame.midX, y: cellFrame.minY ))
            path.line(to: CGPoint(x: cellFrame.maxX, y: cellFrame.minY ))
            path.line(to: CGPoint(x: cellFrame.maxX, y: cellFrame.maxY ))
            path.line(to: CGPoint(x: cellFrame.minX + focusRingCornerRadius, y: cellFrame.maxY ))
            path.curve(to: CGPoint(x: cellFrame.minX, y: cellFrame.maxY - focusRingCornerRadius ), controlPoint1: CGPoint(x: cellFrame.minX + focusRingCornerRadius, y: cellFrame.maxY ), controlPoint2: CGPoint(x: cellFrame.minX, y: cellFrame.maxY ))
            path.line(to: CGPoint(x: cellFrame.minX, y: cellFrame.minY + focusRingCornerRadius))
            path.curve(to: CGPoint(x: cellFrame.minX + focusRingCornerRadius, y: cellFrame.minY), controlPoint1: CGPoint(x: cellFrame.minX, y: cellFrame.minY + focusRingCornerRadius), controlPoint2: CGPoint(x: cellFrame.minX, y: cellFrame.minY ))
            path.line(to: CGPoint(x: cellFrame.midX, y: cellFrame.minY ))
        } else {
            path.appendRoundedRect(cellFrame, xRadius: focusRingCornerRadius, yRadius: focusRingCornerRadius)
        }
        path.fill()
    }
}
