@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class InputToggleRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var inputToggle: FakeInputToggle!
    private var inputToggleRenderer: InputToggleRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        inputToggle = .make()
        inputToggleRenderer = InputToggleRenderer()
    }
    
    func testRendererSetsTitle() {
        let title = "Hello world!"
        inputToggle = .make(title: title)
        
        let inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.title, title)
    }
    
    func testRendererSetsValue() {
        let value = "true"
        inputToggle = .make(value: value)
        
        var inputToggleView = renderInputToggleView()
        var buttonState = (inputToggleView.state.rawValue)
        var booleanValue : String = buttonState == 1 ? "true" : "false"
        XCTAssertEqual(booleanValue, value)
        
        inputToggle = .make(value: "false")
        inputToggleView = renderInputToggleView()
        buttonState = (inputToggleView.state.rawValue)
        booleanValue = buttonState == 1 ? "true" : "false"
        XCTAssertEqual(booleanValue, "false")
    }
    
    func testRendererSetsValueOn() {
        inputToggle = .make(value: "true", valueOn: "false", valueOff: "true")
        
        var inputToggleView = renderInputToggleView()
        var buttonState = (inputToggleView.state.rawValue)
        var booleanValue : String = buttonState == 1 ? "false" : "true"
        XCTAssertEqual(booleanValue, "true")
        
        inputToggle = .make(value: "false", valueOn: "true", valueOff: "false")
        inputToggleView = renderInputToggleView()
        buttonState = inputToggleView.state.rawValue
        booleanValue = buttonState == 1 ? "true" : "false"
        XCTAssertEqual(booleanValue, "false")
    }
    
    func testRendererSetsValueOff() {
        inputToggle = .make(value: "true", valueOn: "true", valueOff: "false")
        
        var inputToggleView = renderInputToggleView()
        var buttonState = (inputToggleView.state.rawValue)
        var booleanValue : String = buttonState == 1 ? "true" : "false"
        XCTAssertEqual(booleanValue, "true")
        
        inputToggle = .make(value: "false", valueOn: "false", valueOff: "true")
        inputToggleView = renderInputToggleView()
        buttonState = inputToggleView.state.rawValue
        booleanValue = buttonState == 1 ? "false" : "true"
        XCTAssertEqual(booleanValue, "false")
    }
    
    
    private func renderInputToggleView() -> ACRInputToggleView {
        let view = inputToggleRenderer.render(element: inputToggle, with: hostConfig, style: .default, rootView: NSView(), parentView: NSView(), inputs: [])
        
        XCTAssertTrue(view is ACRInputToggleView)
        guard let inputToggleView = view as? ACRInputToggleView else { fatalError() }
        return inputToggleView
    }
}
