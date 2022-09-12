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

class ACRCompactChoiceSetView: NSView {
    private let renderConfig: RenderConfig
    private let element: ACSChoiceSetInput
    private let style: ACSContainerStyle
    private let hostConfig: ACSHostConfig
    private let rootview: ACRView
    
    private lazy var contentStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.spacing = 0
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private (set) lazy var choiceSetPopup: ACRChoiceSetCompactPopupButton = {
        let view = ACRChoiceSetCompactPopupButton(element: element, renderConfig: renderConfig)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoenablesItems = false
        view.idString = element.getId()
        view.isRequired = element.getIsRequired()
        view.setAccessibilityRoleDescription(renderConfig.localisedStringConfig.choiceSetCompactAccessibilityRoleDescriptor)
        return view
    }()
    
    private let contentView = NSView()
    
    var getStackViews: [NSView] {
        return contentStackView.arrangedSubviews
    }
    
    init(renderConfig: RenderConfig, element: ACSChoiceSetInput, style: ACSContainerStyle, with hostConfig: ACSHostConfig, rootview: ACRView) {
        self.renderConfig = renderConfig
        self.element = element
        self.style = style
        self.hostConfig = hostConfig
        self.rootview = rootview
        super.init(frame: .zero)
        self.setupView()
        self.setupContraints()
        self.rootview.addInputHandler(choiceSetPopup)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        setupChoiceSet()
        contentView.addSubview(choiceSetPopup)
        contentStackView.addArrangedSubview(contentView)
        if element.getHeight() == .stretch {
            setStretchableHeight()
        }
    }
    
    private func setupContraints() {
        contentStackView.constraint(toFill: self)
        choiceSetPopup.constraint(toFill: contentView, padding: 2)
        choiceSetPopup.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        choiceSetPopup.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setupChoiceSet() {
        var index = 0
        if let placeholder = element.getPlaceholder(), !placeholder.isEmpty {
            choiceSetPopup.addItem(withTitle: placeholder)
            if let menuItem = choiceSetPopup.item(at: 0) {
                menuItem.isEnabled = false
            }
            choiceSetPopup.arrayValues.append(nil)
            index += 1
        }
        for choice in element.getChoices() {
            let title = choice.getTitle() ?? ""
            choiceSetPopup.addItem(withTitle: "")
            let item = choiceSetPopup.item(at: index)
            item?.title = title
            // item?.attributedTitle = getAttributedString(title: title, with: hostConfig, style: style, wrap: choiceSetInput.getWrap())
            choiceSetPopup.arrayValues.append(choice.getValue())
            if element.getValue() == choice.getValue() {
                choiceSetPopup.select(item)
                choiceSetPopup.valueSelected = choice.getValue()
            }
            index += 1
        }
    }
    
    private func setStretchableHeight() {
        let padding = StretchableView()
        ACSFillerSpaceManager.configureHugging(view: padding)
        contentStackView.addArrangedSubview(padding)
    }
}

// MARK: ACRChoiceSetFieldCompactView
class ACRChoiceSetCompactPopupButton: NSPopUpButton, InputHandlingViewProtocol {
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    
    public var idString: String?
    public var valueSelected: String?
    public var arrayValues: [String?] = []
    var isRequired = false
    
    public let type: ACSChoiceSetStyle = .compact
    
    private let renderConfig: RenderConfig
    private let label: String?
    private let errorMessage: String?
    
    init(element: ACSChoiceSetInput, renderConfig: RenderConfig) {
        self.renderConfig = renderConfig
        self.label = element.getLabel()
        self.errorMessage = element.getErrorMessage()
        super.init(frame: .zero, pullsDown: false)
        target = self
        action = #selector(popUpButtonUsed(_:))
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRChoiceSetCompactPopupButton else { return }
        contentView.isHighlighted = true
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRChoiceSetCompactPopupButton else { return }
        contentView.isHighlighted = false
    }
    
    @objc private func popUpButtonUsed(_ sender: NSPopUpButton) {
        errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: self)
    }
    
    func showError() {
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        setAccessibilityFocused(true)
        errorDelegate?.inputHandlingViewShouldAnnounceErrorMessage(self, message: nil)
    }
    
    var value: String {
        return arrayValues[indexOfSelectedItem] ?? ""
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    override func accessibilityValue() -> Any? {
        guard renderConfig.supportsSchemeV1_3 else {
            return itemArray[indexOfSelectedItem].title
        }
        var accessibilityLabel = ""
        if let errorDelegate = errorDelegate, errorDelegate.isErrorVisible {
            accessibilityLabel += "Error "
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                accessibilityLabel += errorMessage + ", "
            }
        }
        if let label = label, !label.isEmpty {
            accessibilityLabel += label + ", "
        }
        accessibilityLabel += itemArray[indexOfSelectedItem].title
        return accessibilityLabel
    }
    
    var isValid: Bool {
        return isRequired ? (arrayValues[indexOfSelectedItem] != nil) : true
    }
}
