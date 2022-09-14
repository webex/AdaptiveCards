@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class MultilineInputTextRendererTest: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var inputText: FakeInputText!
    private var multilineInputTextRenderer: TextInputRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        inputText = .make()
        multilineInputTextRenderer = TextInputRenderer()
    }
    
    func testSetPlaceholder() throws {
        let placeholderString: String = "Sample Placeholder"
        inputText = .make(placeholderString: placeholderString, isMultiline: true)
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.multiLineTextView.textView.placeholderAttrString , NSMutableAttributedString(string: placeholderString, attributes: [.foregroundColor: NSColor.placeholderTextColor, .font: RenderConfig.default.inputFieldConfig.font]))
    }
    
    func testRendersValue() throws {
        let valueString: String = "somevalue"
        inputText = .make(value: valueString, isMultiline: true)
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.multiLineTextView.textView.string, valueString)
    }
    
    func testMaxLengthinInitialValue() throws {
        let valueString: String = "a long string of characters"
        inputText = .make(value: valueString, isMultiline: true, maxLength: NSNumber(10))
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.multiLineTextView.textView.string, "a long str")
    }
    
    func testAccessibilityValueSet() {
        let valueString: String = "somevalue"
        let placeholderString: String = "Sample Placeholder"
        inputText = .make(placeholderString: placeholderString, value: valueString, isMultiline: true)
        
        let inputTextField = renderTextInput()
        // Placeholder is added as part of title as it is drawn in Multiline View
        XCTAssertEqual(inputTextField.multiLineTextView.textView.accessibilityPlaceholderValue(), "Sample Placeholder")
        XCTAssertEqual(inputTextField.multiLineTextView.textView.accessibilityValue(), "somevalue")
        
    }
    
    
    
    private func renderTextInput() -> ACRMultilineInputTextView {
        let view = multilineInputTextRenderer.render(element: inputText, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRMultilineInputTextView)
        guard let inputText = view as? ACRMultilineInputTextView else { fatalError() }
        return inputText
    }
}
