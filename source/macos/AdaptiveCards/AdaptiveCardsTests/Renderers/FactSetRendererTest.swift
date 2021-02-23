@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class FactSetRendererTest: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var factSet: FakeFactSet!
    private var factSetRenderer: FactSetRenderer!
    
    override func setUpWithError() throws {
        hostConfig = .make()
        factSet = .make()
        factSetRenderer = FactSetRenderer()
    }
    
    func testSetsFacts() {
        fact.setTitle("Test title")
        fact.setValue("Test value")
        let factArray = [fact]
        
        factSet = .make(factArray: factArray)
        
        let factView = renderFactSet()
        XCTAssertEqual(factView.arr, fact)
    }
    
    private func renderFactSet() -> NSStackView {
        let view = factSetRenderer.render(element: factSet, with: hostConfig, style: .default, rootView: NSView(), parentView: NSView(), inputs: [])
        
        XCTAssert(view is NSStackView)
        guard let factSet = view as? NSStackView else { fatalError() }
        return factSet
    }
}
