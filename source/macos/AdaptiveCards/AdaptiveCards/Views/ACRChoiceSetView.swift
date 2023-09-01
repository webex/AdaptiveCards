import AdaptiveCards_bridge
import AppKit

// MARK: ACRChoiceSetView
class ACRChoiceSetView: NSView, InputHandlingViewProtocol {
    private(set) lazy var stackview: NSStackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    private(set) var isRadioGroup = false
    private(set) var wrap = false
    private var previousButton: ACRChoiceButton?
    private var idString: String?
    private var errorMessage: String?
    private var shouldShowError = false
    
    private let renderConfig: RenderConfig
    private let inputElement: ACSChoiceSetInput
    private let hostConfig: ACSHostConfig
    private let style: ACSContainerStyle
    private weak var rootView: ACRView?
    var isRequired = false
    
    // AccessibleFocusView property
    weak var exitView: AccessibleFocusView?
    
    init(config: RenderConfig, inputElement: ACSChoiceSetInput, hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView) {
        self.inputElement = inputElement
        self.renderConfig = config
        self.hostConfig = hostConfig
        self.style = style
        self.rootView = rootView
        super.init(frame: .zero)
        isRadioGroup = !inputElement.getIsMultiSelect()
        wrap = inputElement.getWrap()
        idString = inputElement.getId()
        isRequired = inputElement.getIsRequired()
        errorMessage = inputElement.getErrorMessage()
        setupView()
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackview)
        setupChoices()
    }
    
    private func setupConstraints() {
        stackview.constraint(toFill: self)
    }
    
    private func setupChoices() {
        let defaultParsedValues = parseChoiceSetInputDefaultValues(value: inputElement.getValue() ?? "")
        for choice in inputElement.getChoices() {
            guard let rootView = rootView else { continue }
            let title = choice.getTitle() ?? ""
            let attributedString = TextUtils.getRenderAttributedString(text: title, with: hostConfig, renderConfig: renderConfig, rootView: rootView, style: style)
            let choiceButton = self.setupButton(attributedString: attributedString, value: choice.getValue(), for: inputElement)
            if defaultParsedValues.contains(choice.getValue() ?? "") {
                choiceButton.state = .on
                choiceButton.buttonValue = choice.getValue()
                previousButton = choiceButton
            }
            choiceButton.buttonLabelField.openLinkCallBack = { urlAddress in
                URLUtils.open(urlAddress)
            }
            addChoiceButton(choiceButton)
        }
    }
    
    private func parseChoiceSetInputDefaultValues(value: String) -> [String] {
        return value.components(separatedBy: ",")
    }
    
    private func handleClickAction(_ clickedButton: ACRChoiceButton) {
        shouldShowError = false
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
    
    private func addChoiceButton(_ choiceButton: ACRChoiceButton) {
        choiceButton.delegate = self
        stackview.addArrangedSubview(choiceButton)
    }
    
    private func setupButton(attributedString: NSMutableAttributedString, value: String?, for element: ACSChoiceSetInput) -> ACRChoiceButton {
        let newButton = ACRChoiceButton(renderConfig: renderConfig, buttonType: isRadioGroup ? .radio : .switch, element: element, title: attributedString.string)
        newButton.labelAttributedString = attributedString
        newButton.buttonValue = value
        return newButton
    }
    
    func showError() {
        shouldShowError = true
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
    
    var getArrangedSubviews: [NSView] {
        return stackview.arrangedSubviews
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isErrorShown: Bool {
        return shouldShowError
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
        return delegate.isErrorVisible(self)
    }
}

extension ACRChoiceSetView: AccessibleFocusView {
    var validKeyView: NSView? {
        return (self.stackview.arrangedSubviews.first as? ACRChoiceButton)?.button
    }
    
    func setupInternalKeyviews() {
        for index in 0..<stackview.arrangedSubviews.count {
            guard let choiceButton = stackview.arrangedSubviews[index] as? ACRChoiceButton else { continue }
            if index == stackview.arrangedSubviews.count - 1 {
                choiceButton.exitView = self.exitView?.validKeyView
            } else {
                guard let nextChoiceButton = stackview.arrangedSubviews[index + 1] as? ACRChoiceButton else { continue }
                choiceButton.exitView = nextChoiceButton.button
            }
            choiceButton.setupInternalKeyViews()
        }
    }
}
