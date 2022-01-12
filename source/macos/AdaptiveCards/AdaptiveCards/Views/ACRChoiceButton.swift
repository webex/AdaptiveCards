import AppKit

enum ChoiceSetButtonType {
    case radio
    case `switch`
}

protocol ACRChoiceButtonDelegate: NSObjectProtocol {
    func acrChoiceButtonDidSelect(_ button: ACRChoiceButton)
}

class ACRChoiceButton: NSView, NSTextFieldDelegate, InputHandlingViewProtocol {
    weak var delegate: ACRChoiceButtonDelegate?
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    
    public var buttonValue: String?
    public var idString: String?
    public var valueOn: String?
    public var valueOff: String?
    
    private let buttonConfig: ChoiceSetButtonConfig?
    private let buttonType: ChoiceSetButtonType
    private let localisedStringConfig: LocalisedStringConfig
    var isRequired = false
    
    init(renderConfig: RenderConfig, buttonType: ChoiceSetButtonType) {
        self.buttonType = buttonType
        self.buttonConfig = buttonType == .switch ? renderConfig.checkBoxButtonConfig : renderConfig.radioButtonConfig
        self.localisedStringConfig = renderConfig.localisedStringConfig
        super.init(frame: .zero)
        button.setButtonType(buttonType == .switch ? .switch : .radio)
        setupViews()
        setupConstraints()
        setupActions()
        updateButtonImage()
        setupTrackingArea()
        setupAccessibility()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Label
    private (set) lazy var label: NSTextField = {
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
    private (set) lazy var button: NSButton = {
        let view = NSButton()
        view.title = ""
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Click on Text to change state
    override func mouseDown(with event: NSEvent) {
        state = buttonType == .switch && state == .on ? .off : .on
        if  state == .on {
            handleButtonAction()
        }
        updateButtonImage()
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
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: buttonConfig?.elementSpacing ?? 8).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    private func setupAccessibility() {
        setAccessibilityElement(true)
        setAccessibilityRole(buttonType == .radio ? .radioButton : .checkBox)
    }
    
    override func mouseEntered(with event: NSEvent) {
        button.isHighlighted = true
    }
    override func mouseExited(with event: NSEvent) {
        button.isHighlighted = false
    }
    
    private func updateButtonImage() {
        switch state {
        case .on:
            button.image = buttonConfig?.selectedHighlightedIcon
            button.alternateImage = buttonConfig?.selectedIcon
        case .off:
            button.alternateImage = buttonConfig?.highlightedIcon
            button.image = buttonConfig?.normalIcon
        default:
            break
        }
        button.image?.size = NSSize(width: 16, height: 16)
        button.alternateImage?.size = NSSize(width: 16, height: 16)
        button.imageScaling = .scaleProportionallyUpOrDown
        if buttonType == .switch {
            NSAccessibility.announce(valueChangedMessage())
        }
    }
    
    func showError() {
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    @objc private func handleButtonAction() {
        delegate?.acrChoiceButtonDidSelect(self)
        updateButtonImage()
        if buttonType == .radio {
            NSAccessibility.announce(valueChangedMessage())
        }
        errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: button)
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
        return isRequired ? (state == .on) : true
    }
    
    override func accessibilityValue() -> Any? {
        return state
    }

    private func valueChangedMessage() -> String {
        var message: String
        message = state == .on ? (buttonType == .switch ? localisedStringConfig.choiceSetTickBoxTicked : localisedStringConfig.choiceSetRadioButtonSelected) : (buttonType == .switch ? localisedStringConfig.choiceSetTickBoxUnticked : "")
        message += ", " + (accessibilityLabel() ?? "")
        message += ", " + (accessibilityRole()?.description(with: .none) ?? "")
        return message
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
            updateButtonImage()
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

extension NSAccessibility {
    public static func announce(_ message: String) {
        DispatchQueue.main.asyncAfter(duration: 0.2, execute: {
            self.post(
                element: NSApp.mainWindow as Any,
                notification: .announcementRequested,
                userInfo: [.announcement: message, .priority: NSAccessibilityPriorityLevel.high.rawValue]
            )
        })
    }
}

extension DispatchQueue {
    func asyncAfter(duration: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + duration, execute: execute)
    }
}
