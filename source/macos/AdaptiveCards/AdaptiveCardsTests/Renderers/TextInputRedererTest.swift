@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class TextInputRendererTest: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var inputText: FakeInputText!
    private var textInputRenderer: TextInputRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        inputText = .make()
        textInputRenderer = TextInputRenderer()
    }
    
    func testSetPlaceholder() throws {
        let placeholderString: String = "Sample Placeholder"
        inputText = .make(placeholderString: placeholderString)
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.textView.placeholderString , placeholderString)
    }
    
    func testRendersValue() throws {
        let valueString: String = "somevalue"
        inputText = .make(value: valueString)
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.value, valueString)
    }
    
    func testRendersHeight() throws {
        let valueString: String = "somevalue"
        inputText = .make(value: valueString, heightType: .auto)
        
        var inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.contentStackView.arrangedSubviews.count, 1)
        XCTAssertNil(inputTextField.contentStackView.arrangedSubviews.last as? StretchableView)
        
        inputText = .make(value: valueString, heightType: .stretch)
        inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.contentStackView.arrangedSubviews.count, 2)
        XCTAssertNotNil(inputTextField.contentStackView.arrangedSubviews.last as? StretchableView)
        guard let stretchView = inputTextField.contentStackView.arrangedSubviews.last as? StretchableView else { return XCTFail() }
        XCTAssertEqual(stretchView.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testMaxLengthinInitialValue() throws {
        let valueString: String = "a long string of characters"
        inputText = .make(value: valueString, maxLength: NSNumber(10))
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.value, "a long str")
    }
    
    func testSetAccessibilityValue() {
        let valueString: String = "somevalue"
        inputText = .make(value: valueString)
        
        let inputTextField = renderTextInput()
        XCTAssertEqual(inputTextField.textView.accessibilityChildren()?.count, 1)
        // Check for accessibility title removed since function has been overridden and returns nil for this case
        XCTAssertEqual(inputTextField.textView.accessibilityValue(), "somevalue")
    }
    
    func testSingleLineTextInputHandler() {
        let valueString: String = "somevalue"
        inputText = .make(value: valueString, isRequired: true)
        let fakeRootView = FakeRootView()
        let view = textInputRenderer.render(element: inputText, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: .default)
        guard let inputTextField = view as? ACRSingleLineInputTextView else { fatalError() }
        XCTAssertEqual(fakeRootView.inputHandlers.first as? ACRSingleLineInputTextView, inputTextField)
    }
    
    private func renderTextInput() -> ACRSingleLineInputTextView {
        let view = textInputRenderer.render(element: inputText, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRSingleLineInputTextView)
        guard let inputText = view as? ACRSingleLineInputTextView else { fatalError() }
        return inputText
    }
}


    
