import AdaptiveCards_bridge
import AppKit

// MARK: ACRChoiceSetFieldView
class ACRChoiceSetView: NSView {
    private var stackview = NSStackView()
    
    public var isRadioGroup: Bool = false
    public var previousButton: ACRButton?
    
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
    
    private func handleClickAction(_ abutton: ACRButton) {
        guard isRadioGroup else { return }
        if previousButton?.value != abutton.value {
            previousButton?.state = .off
            previousButton = abutton
        }
    }
    
    public func addChoiceButton(_ choiceButton: ACRButton) {
        choiceButton.delegate = self
        stackview.addArrangedSubview(choiceButton)
    }
}
// MARK: Extension
extension ACRChoiceSetView: ACRButtonDelegate {
    func acrButtonDidSelect(_ button: ACRButton) {
        print("Clicked!!")
        handleClickAction(button)
    }
}

// MARK: ACRChoiceSetFieldCompactView
class ACRChoiceSetFieldCompactView: NSPopUpButton {
    override func viewDidMoveToSuperview() {
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
