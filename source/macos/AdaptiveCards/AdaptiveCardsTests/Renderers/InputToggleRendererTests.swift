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
        XCTAssertEqual(inputToggleView.labelAttributedString.string, title)
    }
    
    func testRendererSetsValue() {
        let value = "true"
        inputToggle = .make(value: value)
        
        var inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .on)
        
        inputToggle = .make(value: "false")
        inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .off)
    }
    
    func testRendererSetsValueOff() {
        inputToggle = .make(value: "true", valueOn: "false", valueOff: "true")
        
        var inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .off)
        
        inputToggle = .make(value: "false", valueOn: "true", valueOff: "false")
        inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .off)
    }
    
    func testRendererSetsValueOn() {
        inputToggle = .make(value: "true", valueOn: "true", valueOff: "false")
        
        var inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .on)
        
        inputToggle = .make(value: "false", valueOn: "false", valueOff: "true")
        inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .on)
    }
    
    func testRendererSetsWrap() {
        inputToggle = .make(title: "Hello World", wrap: false)
        
        var inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.buttonLabelField.cell?.wraps, false)
        
        inputToggle = .make(title: "Hello World", wrap: true)
        inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.buttonLabelField.cell?.wraps, true)
    }
    
    func testRendereSetsAccessiblityLabel() {
        inputToggle = .make(title: "Test", value: "true", valueOn: "false", valueOff: "true")
        
        let inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.state, .off)
        XCTAssertEqual(inputToggleView.accessibilityValue() as? Bool, false)
        
        XCTAssertEqual(inputToggleView.accessibilityRole(), .checkBox)
        XCTAssertEqual(inputToggleView.accessibilityLabel(), "Test")
    }
    
    func testRequiredPropertySet() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        inputToggle = .make(title: "Test", value: "true", valueOn: "false", valueOff: "true", isRequired: true)
        let view = inputToggleRenderer.render(element: inputToggle, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRChoiceButton)
        guard let toggleView = view as? ACRChoiceButton else { fatalError() }
        XCTAssertTrue(toggleView.isRequired)
    }
    
    func testisInValidSet(){
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        inputToggle = .make(title: "Test", value: "true", valueOn: "false", valueOff: "true", isRequired: true)
        let view = inputToggleRenderer.render(element: inputToggle, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRChoiceButton)
        guard let toggleView = view as? ACRChoiceButton else { fatalError() }
        XCTAssertFalse(toggleView.isValid)
    }
    private func renderInputToggleView() -> ACRChoiceButton {
        let view = inputToggleRenderer.render(element: inputToggle, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRChoiceButton)
        guard let inputToggleView = view as? ACRChoiceButton else { fatalError() }
        return inputToggleView
    }
}
