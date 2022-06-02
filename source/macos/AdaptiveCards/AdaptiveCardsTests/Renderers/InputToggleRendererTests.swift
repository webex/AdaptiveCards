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
        XCTAssertNotEqual(inputToggleView.buttonLabelField.textContainer?.heightTracksTextView, false)
        
        inputToggle = .make(title: "Hello World", wrap: true)
        inputToggleView = renderInputToggleView()
        XCTAssertNotEqual(inputToggleView.buttonLabelField.textContainer?.heightTracksTextView, true)
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
    
    
    // This Test Case design for HyperLink MarkDown title in Input.Toggle element.
    
    func testHyperLinkMarkdownInTitleForInputToggle(){
        let buttonHyperLinkTitle = "This is test [Webex](https://www.webex.com)"
        let markDownTestAns = "This is test Webex"
        let hyperlinkIndexAt = 13
        inputToggle = .make(title: buttonHyperLinkTitle, value: "Webex")
        let inputToggleView = renderInputToggleView()
        XCTAssertEqual(inputToggleView.labelAttributedString.string, "This is test Webex")
        XCTAssertEqual(inputToggleView.labelAttributedString.string, markDownTestAns)
        XCTAssertNotNil(inputToggleView.labelAttributedString.attributes(at: hyperlinkIndexAt, effectiveRange: nil)[.link])
    }
    
    // This TestCase design for Multiple MarkDown title in Input.Choice element title text.
    
    func testMarkdownInTitleForExpandedChoiceSet() {
        let markdownString = "_This is **test** [Webex](https://www.webex.com)_"
        let markDownTestAns = "This is test Webex"
        let italicAt = 0
        let boldItalic = 8
        let hyperlinkIndexAt = 13
        
        inputToggle = .make(title: markdownString, value: "Webex")
        let inputToggleView = renderInputToggleView()
        
        XCTAssertEqual(inputToggleView.labelAttributedString.string, markDownTestAns)
        let italicfont = inputToggleView.labelAttributedString.fontAttributes(in: NSRange.init(location: italicAt, length: 3))[.font] as? NSFont
        XCTAssertTrue(italicfont?.fontDescriptor.symbolicTraits.contains(.italic) ?? false)
        let boldItalicfont = inputToggleView.labelAttributedString.fontAttributes(in: NSRange.init(location: boldItalic, length: 3))[.font] as? NSFont
        XCTAssertTrue(boldItalicfont?.fontDescriptor.symbolicTraits.contains([.italic, .bold]) ?? false)
        XCTAssertNotNil(inputToggleView.labelAttributedString.attributes(at: hyperlinkIndexAt, effectiveRange: nil)[.link])
    }
    
    private func renderInputToggleView() -> ACRChoiceButton {
        let view = inputToggleRenderer.render(element: inputToggle, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRChoiceButton)
        guard let inputToggleView = view as? ACRChoiceButton else { fatalError() }
        return inputToggleView
    }
}
