import AdaptiveCards_bridge

class FakeInputToggle: ACSToggleInput {
    public var title: String?
    public var value: String?
    public var valueOn: String?
    public var valueOff: String?
    public var wrap: Bool = false
    public var id: String? = ""
    public var label: String? = ""
    public var visibility: Bool = true
    public var isRequired: Bool = false
    public var errorMessage: String?
    public var separator: Bool = false
    public var height: ACSHeightType = .auto
    
    open override func getTitle() -> String? {
        return title
    }

    open override func setTitle(_ value: String) {
        title = value
    }

    open override func getValue() -> String? {
        return value
    }

    open override func setValue(_ value: String) {
        self.value = value
    }

    open override func getValueOn() -> String? {
        return valueOn
    }
    
    open override func setValueOn(_ value: String) {
        valueOn = value
    }
    
    open override func getValueOff() -> String? {
        return valueOff
    }
    
    open override func setValueOff(_ value: String) {
        valueOff = value
    }
    
    open override func getWrap() -> Bool {
        return wrap
    }

    open override func setWrap(_ value: Bool) {
        wrap = value
    }
    
    open override func getType() -> ACSCardElementType {
        return .toggleInput
    }
    
    open override func getSeparator() -> Bool {
        return false
    }
    
    open override func getId() -> String? {
        return id
    }
    
    override func setId(_ value: String) {
        id = value
    }
    
    override func getIsVisible() -> Bool {
        return visibility
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
extension FakeInputToggle {
    static func make(id: String? = "", title: String? = "", value: String = "false", valueOn: String = "true", valueOff: String = "false", wrap: Bool = false, isRequired: Bool = false, errorMessage: String? = "", label: String? = "", heightType: ACSHeightType = .auto) ->FakeInputToggle {
        let fakeInputToggle = FakeInputToggle()
        fakeInputToggle.id = id
        fakeInputToggle.title = title
        fakeInputToggle.value = value
        fakeInputToggle.valueOn = valueOn
        fakeInputToggle.valueOff = valueOff
        fakeInputToggle.wrap = wrap
        fakeInputToggle.isRequired = isRequired
        fakeInputToggle.errorMessage = errorMessage
        fakeInputToggle.label = label
        fakeInputToggle.height = heightType
        return fakeInputToggle
    }
}
