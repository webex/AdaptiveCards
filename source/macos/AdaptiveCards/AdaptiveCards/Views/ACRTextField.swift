import AdaptiveCards_bridge
import AppKit

class ACRTextField: NSTextField {
    var isDarkMode: Bool = false
    
    init(frame frameRect: NSRect, config: RenderConfig) {
        super.init(frame: frameRect)
        initialise(config: config)
        setupConstraints(config: config)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialise(config: RenderConfig) {
        self.isDarkMode = config.isDarkMode
        let myCell = VerticallyCenteredTextFieldCell()
        let inputConfig = config.inputFieldConfig
        myCell.setupSpacing(rightPadding: inputConfig.rightPadding, leftPadding: inputConfig.leftPadding, focusRingCornerRadius: inputConfig.focusRingCornerRadius, borderWidth: inputConfig.borderWidth)
        self.cell = myCell
        self.font = .systemFont(ofSize: inputConfig.fontSize)
        if inputConfig.wantsClearButton {
            self.addSubview(clearButton)
        }
    }
    
    func setupConstraints(config: RenderConfig) {
        let inputConfig = config.inputFieldConfig
        self.heightAnchor.constraint(equalToConstant: inputConfig.height).isActive = true
        if inputConfig.wantsClearButton {
            clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inputConfig.rightPadding).isActive = true
            clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
    }
    
    private (set) lazy var clearButton: NSButtonWithImageSpacing = {
        let resourceName = isDarkMode ? "cancel_16_w" : "cancel_16"
        let view = NSButtonWithImageSpacing(image: BundleUtils.getImage(resourceName, ofType: "png") ?? NSImage(), target: self, action: #selector(handleClearAction))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        view.isBordered = false
        return view
    }()
    
    @objc private func handleClearAction() {
        self.stringValue = ""
    }
}

 class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    var rightPadding: CGFloat = 0
    var leftPadding: CGFloat = 0
    var yPadding: CGFloat = 0
    var focusRingCornerRadius: CGFloat = 0
    var borderWidth: CGFloat = 0.1
    
    override init(textCell string: String) {
        super.init(textCell: string)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSpacing(rightPadding: CGFloat = 0, leftPadding: CGFloat = 0, yPadding: CGFloat = 0, focusRingCornerRadius: CGFloat = 0, borderWidth: CGFloat = 0.1) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.yPadding = yPadding
        self.focusRingCornerRadius = focusRingCornerRadius
        self.borderWidth = borderWidth
    }

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight
        titleRect.origin.x += leftPadding
        titleRect.size.width -= rightPadding + leftPadding
        return titleRect
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        controlView.layer?.borderWidth = borderWidth
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        controlView.layer?.borderWidth = borderWidth
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        let path = NSBezierPath(roundedRect: cellFrame, xRadius: focusRingCornerRadius, yRadius: focusRingCornerRadius)
        path.fill()
    }
 }
