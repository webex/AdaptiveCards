import AdaptiveCards_bridge

class FakeInputTime: ACSTimeInput {
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
}

extension FakeInputTime {
    static func make(value: String? = "", placeholder: String? = "", max: String? = "", min: String? = "", isRequired: Bool = false, errorMessage: String? = "", label: String? = "", separator: Bool = false, heightType: ACSHeightType = .auto) -> FakeInputTime {
        let fakeInputTime = FakeInputTime()
        fakeInputTime.value = value
        fakeInputTime.placeholder = placeholder
        fakeInputTime.max = max
        fakeInputTime.min = min
        fakeInputTime.isRequired = isRequired
        fakeInputTime.errorMessage = errorMessage
        fakeInputTime.label = label
        fakeInputTime.separator = separator
        fakeInputTime.height = heightType
        return fakeInputTime
    }
}
