import AdaptiveCards_bridge
import AppKit
import Carbon.HIToolbox.Events

open class InputNumberRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = InputNumberRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let inputElement = element as? ACSNumberInput else {
            logError("Element is not of type ACSNumberInput")
            return NSView()
        }
        
        // setting up basic properties for Input.Number TextField
        let inputField: ACRNumericTextField = {
            let view = ACRNumericTextField(config: config, inputElement: inputElement)
            view.placeholder = inputElement.getPlaceholder() ?? ""
            view.maxValue = inputElement.getMax()?.doubleValue ?? ACRNumericTextField.MAXVAL
            view.minValue = inputElement.getMin()?.doubleValue ?? ACRNumericTextField.MINVAL
            view.value = inputElement.getValue()?.stringValue ?? ""
            view.isRequired = inputElement.getIsRequired()
            return view
        }()
        
        inputField.stepperShouldWrapValues(false)
        inputField.id = inputElement.getId()
        rootView.addInputHandler(inputField)
        
        if inputElement.getHeight() == .stretch {
            inputField.setStretchableHeight()
        }
        return inputField
    }
}

// MARK: - ACRNumericTextField Class
open class ACRNumericTextField: NSView, NSTextFieldDelegate {
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    private let inputElement: ACSBaseInputElement
    var isRequired = false
    var id: String?
    
    private var previousValue = ""
    private let config: RenderConfig
    
    private (set) lazy var contentStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.spacing = 0
        view.alignment = .leading
        return view
    }()
    
    private var contentView = NSView()
    
    init(config: RenderConfig, inputElement: ACSBaseInputElement) {
        self.inputElement = inputElement
        self.config = config
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setUpControls()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private (set) lazy var textField: ACRTextField = {
        let view = ACRTextField(textFieldWith: config, mode: .number, inputElement: inputElement)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isEditable = true
        view.stringValue = ""
        view.cell?.usesSingleLineMode = true
        view.maximumNumberOfLines = 1
        view.cell?.lineBreakMode = .byTruncatingTail
        view.setAccessibilityRoleDescription(config.localisedStringConfig.inputNumberAccessibilityTitle)
        if #available(OSX 10.13, *) {
            view.layer?.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        return view
    }()

    private lazy var stepper: NSStepper = {
        let view = NSStepper()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setAccessibilityValue("")
        view.setAccessibilityTitle(accessibilityTitle())
        return view
    }()

    @objc private func handleStepperAction(_ sender: NSStepper) {
        value = String(sender.integerValue)
    }
    
    public func controlTextDidChange(_ obj: Notification) {
        guard let textfield = obj.object as? ACRTextField else { return }
        var stringValue = textfield.stringValue
        
        let charSet = NSCharacterSet(charactersIn: "1234567890.-").inverted
        let chars = stringValue.components(separatedBy: charSet)
        stringValue = chars.joined()

        // Only 1 "." should be handled
        let comma = NSCharacterSet(charactersIn: ".")
        let chuncks = stringValue.components(separatedBy: comma as CharacterSet)
        switch chuncks.count {
        case 0:
            stringValue = ""
        case 1:
            stringValue = "\(chuncks[0])"
        default:
            stringValue = "\(chuncks[0]).\(chuncks[1])"
        }
        
        // "-" should be at start if preset
        let minus = NSCharacterSet(charactersIn: "-")
        let minusSeparatedChuncks = stringValue.components(separatedBy: minus as CharacterSet)
        switch minusSeparatedChuncks.count {
        case 0:
            stringValue = ""
        case 1:
            stringValue = "\(minusSeparatedChuncks[0])"
        default:
            if minusSeparatedChuncks[0].isEmpty {
                stringValue = "-\(minusSeparatedChuncks[1])"
            } else {
                stringValue = "\(minusSeparatedChuncks[0])"
            }
        }

        // replace string
        value = stringValue
        previousValue = value
    }
    
    override open func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_UpArrow:
            stepper.integerValue += 1
            value = stepper.stringValue
        case kVK_DownArrow:
            stepper.integerValue -= 1
            value = stepper.stringValue
        case kVK_Space:
            break
        default:
            super.keyDown(with: event)
        }
    }
    
    override open func accessibilityTitle() -> String? {
        return textField.accessibilityTitle()
    }
    
    private func setupViews() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(contentView)
        contentView.addSubview(textField)
        contentView.addSubview(stepper)
    }
    
    private func setupConstraints() {
        contentStackView.constraint(toFill: self)
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stepper.leadingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        stepper.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func setUpControls() {
        stepper.target = self
        stepper.action = #selector(handleStepperAction(_:))
    }
    
    private func hideErrorIfNeeded() {
        let currentFocusedView = stepper.isViewInFocus ? stepper : textField
        if isValid {
            errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: currentFocusedView)
            textField.hideError()
        }
    }
    
    func setStretchableHeight() {
        let padding = StretchableView()
        ACSFillerSpaceManager.configureHugging(view: padding)
        self.contentStackView.addArrangedSubview(padding)
    }
}

// MARK: - EXTENSION
extension ACRNumericTextField: InputHandlingViewProtocol {
    static let MAXVAL = Double.greatestFiniteMagnitude
    static let MINVAL = -MAXVAL
    
    var isErrorShown: Bool {
        return textField.isErrorShown()
    }
    
    var minValue: Double {
        get { return stepper.minValue }
        set { stepper.minValue = newValue }
    }
    
    var maxValue: Double {
        get { return stepper.maxValue }
        set { stepper.maxValue = newValue }
    }
    
    var attributedPlaceholder: NSAttributedString {
        get { return textField.placeholderAttributedString ?? NSAttributedString(string: "") }
        set { textField.placeholderAttributedString = newValue }
    }
    
    var placeholder: String {
        get { return textField.placeholderString ?? "" }
        set { textField.placeholderString = newValue }
    }
    
    func setNumericFormatter(_ formatter: NumberFormatter) {
        textField.formatter = formatter
    }
    
    func stepperShouldWrapValues(_ shouldWrap: Bool) {
        stepper.valueWraps = shouldWrap
    }
    
    func showError() {
        textField.showError()
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    func setAccessibilityFocus() {
        textField.setAccessibilityFocused(true)
        errorDelegate?.inputHandlingViewShouldAnnounceErrorMessage(self, message: accessibilityTitle())
    }
    
    var value: String {
        get {
            if textField.stringValue.isEmpty {
                return ""
            } else if textField.doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                return String(textField.integerValue)
            }
            return String(textField.doubleValue)
        }
        set {
            textField.stringValue = newValue
            stepper.stringValue = newValue
            stepper.setAccessibilityValue(newValue)
            hideErrorIfNeeded()
        }
    }
    
    var key: String {
        guard let id = id else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        guard isBasicValidationsSatisfied else { return false }
        let currValue = Double(value) ?? 0
        return currValue <= maxValue && currValue >= minValue
    }
}

extension ACRNumericTextField: ACRTextFieldDelegate {
    func acrTextFieldDidSelectClear(_ textField: ACRTextField) {
        value = ""
    }
}
