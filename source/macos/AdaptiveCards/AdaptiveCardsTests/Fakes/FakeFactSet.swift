import AdaptiveCards_bridge

class FakeFactSet: ACSFactSet {
    public var fakeFact = FakeFacts()
    
    public var factArray: [FakeFacts]?
//    var fact = ACSFact()
    
    override func getFacts() -> [ACSFact] {
//        fakeFactElement = .make()
        return factArray ?? [fakeFact]
    }
}

extension FakeFactSet {
    static func make(factArray: [FakeFacts]? = nil) -> FakeFactSet {
        let fakeFactSet = FakeFactSet()
        fakeFactSet.factArray = factArray ?? [fakeFactSet.fakeFact]
        return fakeFactSet
    }
}
