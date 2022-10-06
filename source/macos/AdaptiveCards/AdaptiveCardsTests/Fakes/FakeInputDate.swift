import AdaptiveCards_bridge

class FakeInputDate: ACSDateInput {
    public var value: String?
    public var placeholder: String?
    public var max: String?
    public var min: String?
    public var id: String? = ""
    public var visibility: Bool = true
    public var isRequired: Bool = false
    public var errorMessage: String?
    public var label: String?
    public var separator: Bool = false
    public var height: ACSHeightType = .auto

    open override func getValue() -> String? {
        return value
    }
    
    open override func setValue(_ value: String?) {
        self.value = value
    }
    
    open override func getPlaceholder() -> String? {
        return placeholder
    }
    
    override func setPlaceholder(_ value: String) {
        placeholder = value
    }
    
    override func getMax() -> String? {
        return max
    }
    
    override func setMax(_ value: String?) {
        max = value
    }
    
    override func getMin() -> String? {
        return min
    }
    
    override func setMin(_ value: String?) {
        min = value
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
    
    open override func getType() -> ACSCardElementType {
        return .dateInput
    }
}

extension FakeInputDate {
    static func make(id: String? = "", value: String? = "", placeholder: String? = "", max: String? = "", min: String? = "", isRequired: Bool = false, errorMessage: String? = "", label: String? = "", separator: Bool = false, heightType: ACSHeightType = .auto) -> FakeInputDate {
        let fakeInputDate = FakeInputDate()
        fakeInputDate.id = id
        fakeInputDate.value = value
        fakeInputDate.placeholder = placeholder
        fakeInputDate.max = max
        fakeInputDate.min = min
        fakeInputDate.isRequired = isRequired
        fakeInputDate.errorMessage = errorMessage
        fakeInputDate.label = label
        fakeInputDate.separator = separator
        fakeInputDate.height = heightType
        return fakeInputDate
    }
}
