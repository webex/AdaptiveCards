import AdaptiveCards_bridge

class FakeFactSet: ACSFactSet {
    public var factArray: [ACSFact]? = nil
    var fact = ACSFact()
    
    override func getFacts() -> [ACSFact] {
        return factArray ?? [fact]
    }
}

extension FakeFactSet {
    static func make(factArray: [ACSFact]? = nil) -> FakeFactSet {
        let fakeFactSet = FakeFactSet()
        fakeFactSet.factArray = factArray
        return fakeFactSet
    }
}
