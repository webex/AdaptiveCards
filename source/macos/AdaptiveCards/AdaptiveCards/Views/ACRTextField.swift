import AdaptiveCards_bridge
import AppKit

class ACRTextField: NSTextField {
    private let config: InputFieldConfig
    
    init(frame frameRect: NSRect, config: RenderConfig) {
        self.config = config.inputFieldConfig
        super.init(frame: frameRect)
        initialise()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialise() {
        let customCell = VerticallyCenteredTextFieldCell()
        customCell.setupSpacing(rightPadding: config.rightPadding, leftPadding: config.leftPadding, focusRingCornerRadius: config.focusRingCornerRadius, borderWidth: config.borderWidth, borderColor: config.borderColor)
        cell = customCell
        font = config.font
        if config.wantsClearButton {
            addSubview(clearButton)
            clearButton.isHidden = true
        }
        // Add inintial backgound color to text box
        wantsLayer = true
        layer?.backgroundColor = config.backgroundColor.cgColor
    }
    
    private func setupConstraints() {
        heightAnchor.constraint(equalToConstant: config.height).isActive = true
        if config.wantsClearButton {
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -config.rightPadding).isActive = true
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    private (set) lazy var clearButton: NSButtonWithImageSpacing = {
        let view = NSButtonWithImageSpacing(image: config.buttonImage ?? NSImage(), target: self, action: #selector(handleClearAction))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        view.isBordered = false
        return view
    }()
    
    private var textFieldIsEmpty: Bool = true {
        didSet {
            if textFieldIsEmpty == false {
                clearButton.isHidden = false
            } else {
                clearButton.isHidden = true
            }
        }
    }
    
    @objc private func handleClearAction() {
        self.stringValue = ""
        textFieldIsEmpty = true
    }

    override func textDidChange(_ notification: Notification) {
        if textFieldIsEmpty == true {
            textFieldIsEmpty = false
        }
        if stringValue.isEmpty && textFieldIsEmpty == false {
            textFieldIsEmpty = true
        }
        super.textDidChange(notification)
    }
    
    override var attributedStringValue: NSAttributedString {
        didSet {
            if !attributedStringValue.string.isEmpty && textFieldIsEmpty == true {
                textFieldIsEmpty = false
            }
        }
    }
}

 class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    private var rightPadding: CGFloat = 0
    private var leftPadding: CGFloat = 0
    private var yPadding: CGFloat = 0
    private var focusRingCornerRadius: CGFloat = 0
    private var borderWidth: CGFloat = 0.1
    private var borderColor: NSColor = .black

    func setupSpacing(rightPadding: CGFloat = 0, leftPadding: CGFloat = 0, yPadding: CGFloat = 0, focusRingCornerRadius: CGFloat = 0, borderWidth: CGFloat = 0.1, borderColor: NSColor = .black) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.yPadding = yPadding
        self.focusRingCornerRadius = focusRingCornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight
        titleRect.origin.x += leftPadding
        // 16px is the image size(clear button)
        titleRect.size.width -= rightPadding + leftPadding + 16
        return titleRect
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        controlView.layer?.borderWidth = borderWidth
        controlView.layer?.borderColor = borderColor.cgColor
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        controlView.layer?.borderWidth = borderWidth
        controlView.layer?.borderColor = borderColor.cgColor
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        let path = NSBezierPath(roundedRect: cellFrame, xRadius: focusRingCornerRadius, yRadius: focusRingCornerRadius)
        path.fill()
    }
 }
