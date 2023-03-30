@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ChoiceSetInputRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var choiceSetInput: FakeChoiceSetInput!
    private var choiceSetInputRenderer: ChoiceSetInputRenderer!
    private var choices: [ACSChoiceInput] = []
    private var button: FakeChoiceInput!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        choiceSetInput = .make()
        choiceSetInputRenderer = ChoiceSetInputRenderer()
        button = .make()
        choices.append(button)
    }
    
    func testRendererSetChoiceStyle() {
        choiceSetInput = .make(choices: choices, choiceSetStyle: .compact)
        
        let choiceSetCompactView = renderChoiceSetCompactView()
        XCTAssertEqual(choiceSetCompactView.choiceSetPopup.type, .compact)
        
        choiceSetInput = .make(choices: choices, choiceSetStyle: .expanded)
        
        let choiceSetView = renderChoiceSetView()
        XCTAssertEqual(choiceSetView.isRadioGroup, true)
    }
    
    func testExpandChoiceHeightProperty() {
        choiceSetInput = .make(choices: choices, choiceSetStyle: .expanded, heightType: .auto)
        
        var expandChoiceSet = renderChoiceSetView()
        XCTAssertEqual(expandChoiceSet.isRadioGroup, true)
        XCTAssertEqual(expandChoiceSet.getArrangedSubviews.count, 1)
        XCTAssertNil(expandChoiceSet.getArrangedSubviews.last as? StretchableView)
        
        choiceSetInput = .make(choices: choices, choiceSetStyle: .expanded, heightType: .stretch)
        
        expandChoiceSet = renderChoiceSetView()
        XCTAssertEqual(expandChoiceSet.isRadioGroup, true)
        XCTAssertEqual(expandChoiceSet.getArrangedSubviews.count, 2)
        XCTAssertNotNil(expandChoiceSet.getArrangedSubviews.last as? StretchableView)
        guard let stretchView = expandChoiceSet.getArrangedSubviews.last as? StretchableView else { return XCTFail() }
        XCTAssertEqual(stretchView.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testCompactChoiceHeightProperty() {
        choiceSetInput = .make(choices: choices, choiceSetStyle: .compact, heightType: .auto)
        
        var choiceSetCompactView = renderChoiceSetCompactView()
        XCTAssertEqual(choiceSetCompactView.choiceSetPopup.type, .compact)
        XCTAssertEqual(choiceSetCompactView.getArrangedSubviews.count, 1)
        XCTAssertNil(choiceSetCompactView.getArrangedSubviews.last as? StretchableView)
        
        choiceSetInput = .make(choices: choices, choiceSetStyle: .compact, heightType: .stretch)
        
        choiceSetCompactView = renderChoiceSetCompactView()
        XCTAssertEqual(choiceSetCompactView.choiceSetPopup.type, .compact)
        XCTAssertEqual(choiceSetCompactView.getArrangedSubviews.count, 2)
        XCTAssertNotNil(choiceSetCompactView.getArrangedSubviews.last as? StretchableView)
        guard let stretchView = choiceSetCompactView.getArrangedSubviews.last as? StretchableView else { return XCTFail() }
        XCTAssertEqual(stretchView.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testRendererIsMultiSelect() {
        button = .make(title: "Blue", value: "2")
        choices.append(button)
        choiceSetInput = .make(isMultiSelect: true, value: "1,2", choices: choices)
        
        let choiceSetView = renderChoiceSetView()
        
        XCTAssertEqual(choiceSetView.isRadioGroup, false)
    }
    
    func testRendererSetsWrap() {
        // test wrap for radio button
        choiceSetInput = .make(isMultiSelect: false, value: "1", choices: choices, wrap: true)
        
        let choiceSetRadioView = renderChoiceSetView()
        XCTAssertEqual(choiceSetRadioView.wrap, true)
        
        // test wrap for check button
        choiceSetInput = .make(isMultiSelect: true, value: "1,2", choices: choices, wrap: true)
        
        let choiceSetCheckView = renderChoiceSetView()
        XCTAssertEqual(choiceSetCheckView.wrap, true)
    }
    
    func testRequiredPropertySetForCompactChoiceSet() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        choiceSetInput = .make(choices: choices, choiceSetStyle: .compact, isRequired: true)
        let view = choiceSetInputRenderer.render(element: choiceSetInput, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRCompactChoiceSetView)
        guard let choiceSetView = view as? ACRCompactChoiceSetView else { fatalError() }
        XCTAssertTrue(choiceSetView.choiceSetPopup.isRequired)
    }
    
    func testRequiredPropertySetForExpandedChoiceSet() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        choiceSetInput = .make(choices: choices, choiceSetStyle: .expanded, isRequired: true)
        let view = choiceSetInputRenderer.render(element: choiceSetInput, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRChoiceSetView)
        guard let choiceSetView = view as? ACRChoiceSetView else { fatalError() }
        XCTAssertTrue(choiceSetView.isRequired)
    }
    
    func testisInValidSetForCompactChoiceSet(){
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        button = .make(title: "Blue", value: "2")
        choices.append(button)
        choiceSetInput = .make(value: "", choices: choices, choiceSetStyle: .compact, placeholder: "Test", isRequired: true)
        let view = choiceSetInputRenderer.render(element: choiceSetInput, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRCompactChoiceSetView)
        guard let choiceSetView = view as? ACRCompactChoiceSetView else { fatalError() }
        XCTAssertFalse(choiceSetView.choiceSetPopup.isValid)
    }
    
    func testisInValidSetForExpandedChoiceSet(){
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        button = .make(title: "Blue", value: "2")
        choices.append(button)
        choiceSetInput = .make(value: "", choices: choices, choiceSetStyle: .expanded, placeholder: "Test", isRequired: true)
        let view = choiceSetInputRenderer.render(element: choiceSetInput, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRChoiceSetView)
        guard let choiceSetView = view as? ACRChoiceSetView else { fatalError() }
        XCTAssertFalse(choiceSetView.isValid)
    }
    
    func testInputElementStyleAtExpandedChoiceSet() {
        let buttonHyperLinkTitle = "This is test"
        
        self.choiceSetInput = self.makeExpandedChoiceSetInput(title: buttonHyperLinkTitle, value: "Webex test")
        let choiceSetView = renderChoiceSetView()
        guard let acrChoiceBtn = choiceSetView.getArrangedSubviews.first as? ACRChoiceButton else { fatalError() }
        XCTAssertEqual(acrChoiceBtn.buttonLabelField.elementType, .choiceInput)
    }
    
    // This TestCase design for HyperLink MarkDown in Input.Choice element title text.
    
    func testHyperLinkMarkdownInTitleForExpandedChoiceSet() {
        let buttonHyperLinkTitle = "This is test [Webex](https://www.webex.com)"
        let markDownTestAns = "This is test Webex"
        let hyperlinkIndexAt = 13
        
        self.choiceSetInput = self.makeExpandedChoiceSetInput(title: buttonHyperLinkTitle, value: "Webex")
        let choiceSetView = renderChoiceSetView()
        guard let acrChoiceBtn = choiceSetView.getArrangedSubviews.first as? ACRChoiceButton else { fatalError() }
        XCTAssertEqual(acrChoiceBtn.labelAttributedString.string, markDownTestAns)
        XCTAssertNotNil(acrChoiceBtn.labelAttributedString.attributes(at: hyperlinkIndexAt, effectiveRange: nil)[.link])
        XCTAssertTrue(acrChoiceBtn.buttonLabelField.hasLinks)
    }
    
    // This TestCase design for Multiple MarkDown title in Input.Choice element title text.
    
    func testMarkdownInTitleForExpandedChoiceSet() {
        let markdownString = "_This is **test** [Webex](https://www.webex.com)_"
        let markDownTestAns = "This is test Webex"
        let italicAt = 0
        let boldItalic = 8
        let hyperlinkIndexAt = 13
        
        self.choiceSetInput = self.makeExpandedChoiceSetInput(title: markdownString, value: "Webex")
        let choiceSetView = renderChoiceSetView()
        guard let acrChoiceBtn = choiceSetView.getArrangedSubviews.first as? ACRChoiceButton else { fatalError() }
        XCTAssertEqual(acrChoiceBtn.labelAttributedString.string, markDownTestAns)
        let italicfont = acrChoiceBtn.labelAttributedString.fontAttributes(in: NSRange.init(location: italicAt, length: 3))[.font] as? NSFont
        XCTAssertTrue(italicfont?.fontDescriptor.symbolicTraits.contains(.italic) ?? false)
        let boldItalicfont = acrChoiceBtn.labelAttributedString.fontAttributes(in: NSRange.init(location: boldItalic, length: 3))[.font] as? NSFont
        XCTAssertTrue(boldItalicfont?.fontDescriptor.symbolicTraits.contains([.italic, .bold]) ?? false)
        XCTAssertNotNil(acrChoiceBtn.labelAttributedString.attributes(at: hyperlinkIndexAt, effectiveRange: nil)[.link])
        XCTAssertTrue(acrChoiceBtn.buttonLabelField.hasLinks)
    }
    
    func testCompactChoiceSetTooltip() {
        button = .make(title: "Test Title 1", value: "Test Value 1")
        let button2 = FakeChoiceInput.make(title: "Test Title 2", value: "Test Value 2")
        choices.removeAll()
        choices.append(button)
        choices.append(button2)
        choiceSetInput = .make(choices: choices, choiceSetStyle: .compact, heightType: .auto)
        
        let choiceSetCompactView = renderChoiceSetCompactView()
        
        XCTAssertEqual(choiceSetCompactView.choiceSetPopup.toolTip, "Test Title 1")
        XCTAssertEqual(choiceSetCompactView.choiceSetPopup.itemArray[0].toolTip, "Test Title 1")
        XCTAssertEqual(choiceSetCompactView.choiceSetPopup.itemArray[1].toolTip, "Test Title 2")
    }
    
    private func renderChoiceSetView() -> ACRChoiceSetView {
        let view = choiceSetInputRenderer.render(element: choiceSetInput, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRChoiceSetView)
        guard let choiceSetView = view as? ACRChoiceSetView else { fatalError() }
        return choiceSetView
    }
    
    private func renderChoiceSetCompactView() -> ACRCompactChoiceSetView {
        let view = choiceSetInputRenderer.render(element: choiceSetInput, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRCompactChoiceSetView)
        guard let choiceSetCompactView = view as? ACRCompactChoiceSetView else { fatalError() }
        return choiceSetCompactView
    }
    
    private func makeExpandedChoiceSetInput(title: String, value: String) -> FakeChoiceSetInput{
        let choices: [ACSChoiceInput] = [FakeChoiceInput.make(title: title, value: value)]
        return .make(choices: choices, choiceSetStyle: .expanded)
    }
}

