import AppKit

class ACRButton: NSView, NSTextFieldDelegate {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        return true
    }
    
    // Label
    private lazy var label: NSTextField = {
        let view = NSTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.delegate = self
        view.isBordered = false
        view.isHighlighted = false
        return view
    }()
    
    // Button
    private lazy var button: NSButton = {
        let view = NSButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.action = "test"
        return view
    }()
    
    // Click on Text to change state
    override func mouseDown(with event: NSEvent) {
        self.state = self.state == .on ? .off : .on
    }
    
    func setupViews() {
        addSubview(button)
        addSubview(label)
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("entered")
    }
    
    func setupActions() {
        // random action
    }
    
    func setupConstraints() {
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    var labelValue: NSAttributedString {
        get { label.attributedStringValue }
        set {
            label.attributedStringValue = newValue
        }
    }
    override func touchesBegan(with event: NSEvent) {
        super.touchesBegan(with: event)
        print("test")
    }
    var backGroundColor: NSColor {
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
    
    var wrap: Bool {
        get { ((label.cell?.wraps) != nil) }
        set {
            label.cell?.wraps = newValue
        }
    }
    
    var setType: NSButton.ButtonType {
        get { .switch }
        set {
            button.setButtonType(newValue)
        }
    }
    
    var title: String {
        get { button.title }
        set {
            button.title = newValue
        }
    }
    
//    var action: Selector? {
//        get { button.action }
//        set {
//            button.action = "test"
//        }
//    }
    var isEnabled: Bool = true {
        didSet {
            updatebutton()
        }
    }
    var isChecked: Bool = true {
        didSet {
            updatebutton()
        }
    }
    fileprivate func updatebutton() {
        if self.setType == .radio {
            // other buttons false
        }
    }
}
