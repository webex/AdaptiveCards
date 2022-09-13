import AdaptiveCards_bridge
import AppKit

// MARK: ACRChoiceSetView
class ACRChoiceSetView: NSView, InputHandlingViewProtocol {
    private lazy var stackview: NSStackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    public var isRadioGroup = false
    public var previousButton: ACRChoiceButton?
    public var wrap = false
    public var idString: String?
    public var errorMessage: String?
    
    private let renderConfig: RenderConfig
    var isRequired = false
    
    init(renderConfig: RenderConfig) {
        self.renderConfig = renderConfig
        super.init(frame: .zero)
        addSubview(stackview)
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackview.constraint(toFill: self)
    }
    
    private func handleClickAction(_ clickedButton: ACRChoiceButton) {
        errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: clickedButton.button)
        guard isRadioGroup else { return }
        if previousButton != clickedButton {
            previousButton?.state = .off
            previousButton = clickedButton
        } else {
            clickedButton.state = .on
        }
    }
    
    public func setStretchableHeight() {
        let padding = StretchableView()
        ACSFillerSpaceManager.configureHugging(view: padding)
        stackview.addArrangedSubview(padding)
    }
    
    public func addChoiceButton(_ choiceButton: ACRChoiceButton) {
        choiceButton.delegate = self
        stackview.addArrangedSubview(choiceButton)
    }
    
    public func setupButton(attributedString: NSMutableAttributedString, value: String?, for element: ACSChoiceSetInput) -> ACRChoiceButton {
        let newButton = ACRChoiceButton(renderConfig: renderConfig, buttonType: isRadioGroup ? .radio : .switch, element: element, title: attributedString.string)
        newButton.labelAttributedString = attributedString
        newButton.buttonValue = value
        return newButton
    }
    
    func showError() {
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        guard let firstButtonInStack = stackview.arrangedSubviews.first as? ACRChoiceButton else { return }
        firstButtonInStack.button.setAccessibilityFocused(true)
        errorDelegate?.inputHandlingViewShouldAnnounceErrorMessage(self, message: firstButtonInStack.accessibilityLabel())
    }
    
    var value: String {
        var stringOfSelectedValues: [String] = []
        let arrayViews = stackview.arrangedSubviews
        for view in arrayViews {
            if let view = view as? ACRChoiceButton, view.state == .on {
                stringOfSelectedValues.append(view.buttonValue ?? "")
            }
        }
        return stringOfSelectedValues.joined(separator: ",")
    }
    
    var getStackViews: [NSView] {
        return stackview.arrangedSubviews
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        return isRequired ? stackview.arrangedSubviews.contains(where: { let elem = $0 as? ACRChoiceButton; return elem?.state == .on }) : true
    }
}
// MARK: Extension
extension ACRChoiceSetView: ACRChoiceButtonDelegate {
    func acrChoiceButtonDidSelect(_ button: ACRChoiceButton) {
        handleClickAction(button)
    }
    
    func acrChoiceButtonShouldReadError(_ button: ACRChoiceButton) -> Bool {
        guard let delegate = errorDelegate else { return false }
        return delegate.isErrorVisible
    }
}
