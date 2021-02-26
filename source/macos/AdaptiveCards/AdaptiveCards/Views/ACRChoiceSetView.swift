import AdaptiveCards_bridge
import AppKit

// MARK: ACRChoiceSetView
class ACRChoiceSetView: NSView {
    private var stackview = NSStackView()
    
    public var isRadioGroup: Bool = false
    public var previousButton: ACRButton?
    public var wrap: Bool = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(stackview)
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackview.orientation = .vertical
        stackview.alignment = .leading
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func handleClickAction(_ clickedButton: ACRButton) {
        guard isRadioGroup else { return }
        if previousButton?.value != clickedButton.value {
            previousButton?.state = .off
            previousButton = clickedButton
        }
    }
    
    public func addChoiceButton(_ choiceButton: ACRButton) {
        choiceButton.delegate = self
        stackview.addArrangedSubview(choiceButton)
    }
    
    public func setupButton(attributedString: NSMutableAttributedString, value: String?) -> ACRButton {
        let newButton = ACRButton()
        newButton.labelAttributedString = attributedString
        newButton.wrap = self.wrap
        newButton.value = value
        return newButton
    }
}
// MARK: Extension
extension ACRChoiceSetView: ACRButtonDelegate {
    func acrButtonDidSelect(_ button: ACRButton) {
        handleClickAction(button)
    }
}

// MARK: ACRChoiceSetFieldCompactView
class ACRChoiceSetCompactView: NSPopUpButton {
    public let type: ACSChoiceSetStyle = .compact
    override func viewDidMoveToSuperview() {
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
