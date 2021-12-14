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
            let view = ACRNumericTextField(config: config)
            view.placeholder = inputElement.getPlaceholder() ?? ""
            view.maxValue = inputElement.getMax()?.doubleValue ?? ACRNumericTextField.MAXVAL
            view.minValue = inputElement.getMin()?.doubleValue ?? ACRNumericTextField.MINVAL
            view.inputString = inputElement.getValue()?.stringValue ?? ""
            return view
        }()
        
        inputField.stepperShouldWrapValues(false)
        inputField.isHidden = !inputElement.getIsVisible()
        inputField.id = inputElement.getId()
        rootView.addInputHandler(inputField)
        
        return inputField
    }
}

// MARK: - ACRNumericTextField Class
open class ACRNumericTextField: NSView, NSTextFieldDelegate {
    var id: String?
    private var previousValue = ""
    private let config: RenderConfig
    
    init(config: RenderConfig) {
        self.config = config
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setUpControls()
        setAccessibilityLabel("")
        setStepperAccessibilityValue(value: "")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private (set) lazy var textField: ACRTextField = {
        let view = ACRTextField(numericFieldWith: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isEditable = true
        view.stringValue = ""
        view.cell?.usesSingleLineMode = true
        view.maximumNumberOfLines = 1
        view.cell?.lineBreakMode = .byTruncatingTail
        view.setAccessibilityTitle(config.localisedStringConfig.inputNumberAccessibilityTitle)
        if #available(OSX 10.13, *) {
            view.layer?.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        return view
    }()

    private lazy var stepper: NSStepper = {
        let view = NSStepper()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc private func handleStepperAction(_ sender: NSStepper) {
        textField.stringValue = "\(sender.integerValue)"
        setStepperAccessibilityValue(value: String(stepper.integerValue))
    }
    
    public func controlTextDidChange(_ obj: Notification) {
        guard let textfield = obj.object as? ACRTextField else { return }
        var stringValue = textfield.stringValue
        
        stepper.doubleValue = Double(textField.stringValue) ?? stepper.doubleValue
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
        textfield.stringValue = stringValue
        previousValue = textField.stringValue
    }
    
    public func controlTextDidEndEditing(_ obj: Notification) {
        // Handling cases when the text entered is beyond the minimum and maximum allowed values in the field.
        textField.stringValue = value
        setStepperAccessibilityValue(value: value)
    }
    
    func setupViews() {
        addSubview(textField)
        addSubview(stepper)
    }
    
    func setupConstraints() {
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stepper.leadingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        stepper.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stepper.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stepper.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setUpControls() {
        stepper.target = self
        stepper.action = #selector(handleStepperAction(_:))
    }
    
    func setStepperAccessibilityValue(value: String) {
        stepper.setAccessibilityValue(value)
    }
}

// MARK: - EXTENSION
extension ACRNumericTextField: InputHandlingViewProtocol {
    static let MAXVAL = Double.greatestFiniteMagnitude
    static let MINVAL = -MAXVAL
    
    var inputValue: Double {
        get { return textField.doubleValue }
        set {
            textField.doubleValue = newValue
            stepper.doubleValue = newValue
            setStepperAccessibilityValue(value: textField.stringValue)
        }
    }
    
    var inputString: String {
        get { return String(inputValue) }
        set {
            if !newValue.isEmpty, let doubleVal = Double(newValue) {
                inputValue = doubleVal
                previousValue = inputString
            }
        }
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
    
    func setId(idString: String?) {
        self.id = idString
    }
    
    override open func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_UpArrow:
            inputValue += 1
        case kVK_DownArrow:
            inputValue -= 1
        default:
            super.keyDown(with: event)
        }
    }
    
    var value: String {
        if Float(inputValue).truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(inputValue))
        } else {
            return String(Float(inputValue))
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
        return true
    }
    
    weak var errorMessageHandler: ErrorMessageHandlerDelegate? {
        get {
            return textField.errorMessageHandler
        }
        set {
            textField.errorMessageHandler = newValue
        }
    }
}
