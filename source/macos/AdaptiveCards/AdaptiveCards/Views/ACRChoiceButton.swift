import AppKit

protocol ACRChoiceButtonDelegate: NSObjectProtocol {
    func acrChoiceButtonDidSelect(_ button: ACRChoiceButton)
}

class ACRChoiceButton: NSView, NSTextFieldDelegate, InputHandlingViewProtocol {
    weak var delegate: ACRChoiceButtonDelegate?
    public var choiceSetButtonConfig: ChoiceSetButtonConfig = .default
    public var buttonValue: String?
    public var idString: String?
    public var valueOn: String?
    public var valueOff: String?
    
    private let renderConfig: RenderConfig
    private let isMultiSelect: Bool
    
    init(renderConfig: RenderConfig, isMultiSelect: Bool) {
        self.renderConfig = renderConfig
        self.isMultiSelect = isMultiSelect
        super.init(frame: .zero)
        button.setButtonType(.switch)
        setupViews()
        setupConstraints()
        setupActions()
        setupTrackingArea()
        setupButtonImage()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Label
    private lazy var label: NSTextField = {
        let view = NSTextField()
        view.isEditable = false
        view.delegate = self
        view.isBordered = false
        view.isHighlighted = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // Button
    private lazy var button: NSButton = {
        let view = NSButton()
        view.title = ""
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Click on Text to change state
    override func mouseDown(with event: NSEvent) {
        state = state == .on ? .off : .on
        if  state == .on {
            handleButtonAction()
        }
        setupButtonImage()
    }
    
    private func setupViews() {
        addSubview(button)
        addSubview(label)
    }
    
    private func setupActions() {
        // random action
        button.target = self
        button.action = #selector(handleButtonAction)
    }
    
    private func setupConstraints() {
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        button.isHighlighted = true
    }
    override func mouseExited(with event: NSEvent) {
        button.isHighlighted = false
    }
    
    private func setupButtonImage() {
        switch state {
        case .on:
            button.image = !isMultiSelect ? choiceSetButtonConfig.checkOnHoverIcon : choiceSetButtonConfig.radioOnHoverIcon
            button.alternateImage = !isMultiSelect ? choiceSetButtonConfig.checkOnIcon : choiceSetButtonConfig.radioOnIcon
        case .off:
            button.alternateImage = !isMultiSelect ? choiceSetButtonConfig.checkOffHoverIcon : choiceSetButtonConfig.radioOffHoverIcon
            button.image = !isMultiSelect ? choiceSetButtonConfig.checkOffIcon : choiceSetButtonConfig.radioOffIcon
        default:
            break
        }
        button.image?.size = NSSize(width: 16, height: 16)
        button.alternateImage?.size = NSSize(width: 16, height: 16)
        button.imageScaling = .scaleProportionallyUpOrDown
    }
    
    @objc private func handleButtonAction() {
        delegate?.acrChoiceButtonDidSelect(self)
    }
    
    var value: String {
        return (state == .on ? valueOn: valueOff) ?? ""
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        return true
    }
}
// MARK: EXTENSION
extension ACRChoiceButton {
    var backgroundColor: NSColor {
        get { label.backgroundColor ?? .clear }
        set {
            label.backgroundColor = newValue
        }
    }
    
    var labelAttributedString: NSAttributedString {
        get { label.attributedStringValue }
        set {
            label.attributedStringValue = newValue
        }
    }
    
    var state: NSControl.StateValue {
        get { button.state }
        set {
            button.state = newValue
            setupButtonImage()
        }
    }
    
    var wrap: Bool? {
        get { ((label.cell?.wraps) ) }
        set {
            label.cell?.wraps = newValue ?? false
        }
    }
    
    var title: String {
        get { label.stringValue }
        set {
            label.stringValue = newValue
        }
    }
}
