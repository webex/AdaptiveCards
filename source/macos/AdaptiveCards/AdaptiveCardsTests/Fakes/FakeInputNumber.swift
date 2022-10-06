import AdaptiveCards_bridge

class FakeInputNumber: ACSNumberInput {
    public var placeholder: String?
    public var value: NSNumber?
    public var max: NSNumber?
    public var min: NSNumber?
    public var isVisible: Bool?
    public var id: String? = ""
    public var separator: Bool = false
    public var spacing: ACSSpacing = .default
    public var label: String? = ""
    public var isRequired: Bool = false
    public var errorMessage: String?
    public var height: ACSHeightType = .auto
    
    open override func getValue() -> NSNumber? {
        return value
    }
    
    open override func setValue(_ value: NSNumber?) {
        self.value = value
    }
    
    open override func getPlaceholder() -> String? {
        return placeholder
    }
    
    override func setPlaceholder(_ value: String) {
        placeholder = value
    }
    
    override func getMax() -> NSNumber? {
        return max
    }
    
    override func setMax(_ value: NSNumber?) {
        max = value
    }
    
    override func getMin() -> NSNumber? {
        return min
    }
    
    override func setMin(_ value: NSNumber?) {
        min = value
    }
    
    override func getIsVisible() -> Bool {
        return isVisible ?? true
    }
    
    override func setIsVisible(_ value: Bool) {
        isVisible = value
    }
    
    override func getType() -> ACSCardElementType {
        return .numberInput
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func setId(_ value: String) {
        id = value
    }
    
    override func getSeparator() -> Bool {
        return separator
    }
    
    override func getSpacing() -> ACSSpacing {
        return spacing
    }
    
    override func getLabel() -> String? {
        return label
    }
    
    override func setLabel(_ label: String) {
        self.label = label
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
    
    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
}

extension FakeInputNumber {
    static func make(id: String? = "", value: NSNumber? = 0, placeholder: String? = "", max: NSNumber? = 0, min: NSNumber = 0, visible: Bool? = true, separator: Bool = false, spacing: ACSSpacing = .default, label: String? = nil, isRequired: Bool = false, errorMessage: String? = "", heightType: ACSHeightType = .auto) -> FakeInputNumber {
        let fakeInputNumber = FakeInputNumber()
        fakeInputNumber.id = id
        fakeInputNumber.value = value
        fakeInputNumber.placeholder = placeholder
        fakeInputNumber.max = max
        fakeInputNumber.min = min
        fakeInputNumber.isVisible = visible
        fakeInputNumber.separator = separator
        fakeInputNumber.spacing = spacing
        fakeInputNumber.label = label
        fakeInputNumber.isRequired = isRequired
        fakeInputNumber.errorMessage = errorMessage
        fakeInputNumber.height = heightType
        return fakeInputNumber
    }
}
