import AdaptiveCards_bridge

class FakeChoiceSetInput: ACSChoiceSetInput {
    public var isMultiSelect: Bool = false
    public var choiceSetStyle: ACSChoiceSetStyle = .compact
    public var choices: [ACSChoiceInput] = []
    public var placeholder: String?
    public var value: String?
    public var wrap: Bool = false
    public var id: String? = ""
    public var visibility: Bool = true
    public var isRequired: Bool = false
    public var errorMessage: String?
    public var label: String?
    public var separator: Bool = false
    public var height: ACSHeightType = .auto
    
    open override func getIsMultiSelect() -> Bool {
        return isMultiSelect
    }
    
    open override func setIsMultiSelect(_ isMultiSelect: Bool) {
        self.isMultiSelect = isMultiSelect
    }
    
    open override func getChoiceSetStyle() -> ACSChoiceSetStyle {
        return choiceSetStyle
    }
    
    open override func setChoiceSetStyle(_ value: ACSChoiceSetStyle) {
        choiceSetStyle = value
    }
    
    open override func getChoices() -> [ACSChoiceInput] {
        return choices
    }
    
    open override func setPlaceholder(_ value: String) {
        placeholder = value
    }

    open override func getPlaceholder() -> String? {
        return placeholder
    }

    open override func getValue() -> String? {
        return value
    }

    open override func setValue(_ value: String) {
        self.value = value
    }
    
    open override func getWrap() -> Bool {
        return wrap
    }

    open override func setWrap(_ value: Bool) {
        wrap = value
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func setId(_ value: String) {
        id = value
    }
    
    override func getIsVisible() -> Bool {
        return visibility
    }
    
    override func setIsVisible(_ value: Bool) {
        visibility = value
    }
    
    override func getIsRequired() -> Bool {
        return isRequired
    }
    
    override func setIsRequired(_ isRequired: Bool) {
        self.isRequired = isRequired
    }
    
    override func getErrorMessage() -> String? {
        return errorMessage
    }
    
    override func setErrorMessage(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    override func getLabel() -> String? {
        return label
    }
    
    override func setLabel(_ label: String) {
        self.label = label
    }
    
    override func getSeparator() -> Bool {
        return separator
    }
    
    override func setSeparator(_ value: Bool) {
        separator = value
    }
    
    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
}
extension FakeChoiceSetInput {
    static func make(isMultiSelect: Bool = false, id: String = "", value: String = "1", choices: [ACSChoiceInput] = [], wrap: Bool = false, choiceSetStyle: ACSChoiceSetStyle = .expanded, placeholder: String? = "", visibility: Bool = true, isRequired: Bool = false, errorMessage: String? = "", label: String? = "", separator: Bool = false, heightType: ACSHeightType = .auto) -> FakeChoiceSetInput {
        let fakeChoiceSetInput = FakeChoiceSetInput()
        fakeChoiceSetInput.id = id
        fakeChoiceSetInput.placeholder = placeholder
        fakeChoiceSetInput.value = value
        fakeChoiceSetInput.choiceSetStyle = choiceSetStyle
        fakeChoiceSetInput.choices = choices
        fakeChoiceSetInput.isMultiSelect = isMultiSelect
        fakeChoiceSetInput.wrap = wrap
        fakeChoiceSetInput.visibility = visibility
        fakeChoiceSetInput.isRequired = isRequired
        fakeChoiceSetInput.errorMessage = errorMessage
        fakeChoiceSetInput.label = label
        fakeChoiceSetInput.separator = separator
        fakeChoiceSetInput.height = heightType
        return fakeChoiceSetInput
    }
}

