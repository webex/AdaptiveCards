import AdaptiveCards_bridge

class FakeFactSet: ACSFactSet {
    public var factArray: [FakeFacts] = []
    public var height: ACSHeightType = .auto
    
    override func getFacts() -> [ACSFact] {
        return factArray
    }
    
    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
}

extension FakeFactSet {
    static func make(factArray: [FakeFacts] = [], heightType: ACSHeightType = .auto) -> FakeFactSet {
        let fakeFactSet = FakeFactSet()
        fakeFactSet.factArray = factArray
        fakeFactSet.height = heightType
        return fakeFactSet
    }
}
