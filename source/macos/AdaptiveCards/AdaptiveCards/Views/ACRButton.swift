import AppKit

protocol ACRButtonDelegate: NSObjectProtocol {
    func acrButtonDidSelect(_ button: ACRButton)
}

class ACRButton: NSView, NSTextFieldDelegate {
    weak var delegate: ACRButtonDelegate?
    public var value: String?
    public var buttonType: NSButton.ButtonType = .switch
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
        setupConstraints()
        setupActions()
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
        return view
    }()
    
    // Button
    private lazy var button: NSButton = {
        let view = NSButton()
        view.title = ""
        return view
    }()
    
    // Click on Text to change state
    override func mouseDown(with event: NSEvent) {
        self.state = self.state == .on ? .off : .on
        if self.state == .on {
            handleButtonAction()
        }
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    @objc private func handleButtonAction() {
        delegate?.acrButtonDidSelect(self)
    }
}
// MARK: EXTENSION
extension ACRButton {
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
        }
    }
    
    var wrap: Bool? {
        get { ((label.cell?.wraps) ) }
        set {
            label.cell?.wraps = newValue ?? false
        }
    }
    
    var type: NSButton.ButtonType {
        get { buttonType }
        set {
            button.setButtonType(newValue)
            buttonType = newValue
        }
    }
    
    var title: String {
        get { label.stringValue }
        set {
            label.stringValue = newValue
        }
    }
}
