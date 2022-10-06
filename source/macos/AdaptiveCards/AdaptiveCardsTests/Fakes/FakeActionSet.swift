import AdaptiveCards_bridge

class FakeActionSet: ACSActionSet {
    public var actions: [ACSBaseActionElement] = []
    public var horizontalAlignment: ACSHorizontalAlignment = .left
    public var height: ACSHeightType = .auto

    open override func getActions() -> [ACSBaseActionElement] {
        return actions
    }
    
    open override func getHorizontalAlignment() -> ACSHorizontalAlignment {
        return horizontalAlignment
    }
    
    open override func setHorizontalAlignment(_ value: ACSHorizontalAlignment) {
        horizontalAlignment = value
    }
    
    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
}
extension FakeActionSet {
    static func make(actions: [ACSBaseActionElement] = [], aligned alighnment: ACSHorizontalAlignment = .left, heightType: ACSHeightType = .auto) -> FakeActionSet {
        let fakeActionSet = FakeActionSet()
        fakeActionSet.actions = actions
        fakeActionSet.horizontalAlignment = alighnment
        fakeActionSet.height = heightType
        return fakeActionSet
    }
}

