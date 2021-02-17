import AdaptiveCards_bridge

class FakeInputNumber: ACSTextInput {
    public var placeholderString: String?
    public var value: String?
    public var isMultiline: Bool = false
    public var maxLength: NSNumber?
    public var style: ACSTextInputStyle = .text
    public var inlineAction: ACSBaseActionElement? = .none
    public var regexString: String?
    
    override func getPlaceholder() -> String? {
        return self.placeholderString
    }
    
    override func setPlaceholder(_ value: String) {
        self.placeholderString = value
    }
    
    override func getValue() -> String? {
        return self.value
    }
    
    override func setValue(_ value: String) {
        self.value = value
    }
    
    override func getIsMultiline() -> Bool {
        return self.isMultiline
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
}

extension FakeInputNumber {
    static func make(value: NSNumber? = 0, placeholder: String? = "", max: NSNumber? = 0, min: NSNumber = 0, visible: Bool? = true) -> FakeInputNumber {
        let fakeInputNumber = FakeInputNumber()
        fakeInputNumber.value = value
        fakeInputNumber.placeholder = placeholder
        fakeInputNumber.max = max
        fakeInputNumber.min = min
        fakeInputNumber.isVisible = visible
        return fakeInputNumber
    }
}

