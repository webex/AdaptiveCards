@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRChoiceSetViewtests: XCTestCase {
    private var choiceSetView: ACRChoiceSetView!
    private var renderConfig: RenderConfig!
    private var choiceSetInput: FakeChoiceSetInput!
    
    override func setUp() {
        super.setUp()
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: .default,checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        choiceSetInput = FakeChoiceSetInput.make()
        choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: FakeHostConfig(), style: .default, rootView: FakeRootView())
    }
    
    func testACRChoiceSetViewInitsWithoutError() {
        //Test default initialsier
        let choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: FakeHostConfig(), style: .default, rootView: FakeRootView())
        XCTAssertNotNil(choiceSetView)
    }
    
    func testRadioButtonClickAction() throws {
        choiceSetInput = FakeChoiceSetInput.make(isMultiSelect: false, choices: [FakeChoiceInput.make(title: "1", value: "Button1"), FakeChoiceInput.make(title: "2", value: "Button2")])
        choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: FakeHostConfig(), style: .default, rootView: FakeRootView())
        
        // The clicking of the button is handled in ACRChoiceButton and ACRChoiceSetView parallely, with ACRChoiceSetView only making sure the previous radio button is turned off when another radio button is pressed
        // Therefore, to click on the button, button.performClick() is called, and to turn the other button off, choiceSetView.acrChoiceButtondidSelect() is called
        let button1 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.first as? ACRChoiceButton)
        let button2 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.last as? ACRChoiceButton)
        button1.button.performClick(nil)
        XCTAssertEqual(button1.state, .on)
        XCTAssertEqual(button2.state, .off)
        choiceSetView.acrChoiceButtonDidSelect(button1)
        XCTAssertEqual(button1.state, .on)
        XCTAssertEqual(button2.state, .off)
        choiceSetView.acrChoiceButtonDidSelect(button2)
        button2.button.performClick(nil)
        XCTAssertEqual(button1.state, .off)
        XCTAssertEqual(button2.state, .on)
    }
    
    func testChoiceSetRadioButtonAccessibility() throws {
        choiceSetInput = FakeChoiceSetInput.make(isMultiSelect: false, choices: [FakeChoiceInput.make(title: "Button1", value: "1"), FakeChoiceInput.make(title: "Button2", value: "2")])
        choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: FakeHostConfig(), style: .default, rootView: FakeRootView())
        
        let button1 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.first as? ACRChoiceButton)
        let button2 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.last as? ACRChoiceButton)
        XCTAssertEqual(button1.accessibilityRole(), .radioButton)
        XCTAssertEqual(button1.accessibilityLabel(), "Button1")
        XCTAssertEqual(button2.accessibilityLabel(), "Button2")
    }
    
    
    func testChoiceSetFocusAccessibility() throws {
        choiceSetInput = FakeChoiceSetInput.make(isMultiSelect: true, choices: [FakeChoiceInput.make(title: "Hello [Swift 5](www.swift.org)", value: "Swift"), FakeChoiceInput.make(title: "Hello ObjectiveC", value: "ObjectiveC")])
        choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: FakeHostConfig(), style: .default, rootView: FakeRootView())
        choiceSetView.setupInternalKeyviews()
        let button1 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.first as? ACRChoiceButton)
        let button2 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.last as? ACRChoiceButton)
        XCTAssertEqual(button1.button.nextKeyView, button1.buttonLabelField)
        XCTAssertEqual(button1.buttonLabelField.nextKeyView, button2.button)
    }
    
    func testChoiceSetCheckBoxButtonAccessibility() throws {
        choiceSetInput = FakeChoiceSetInput.make(isMultiSelect: true, choices: [FakeChoiceInput.make(title: "Button1", value: "1"), FakeChoiceInput.make(title: "Button2", value: "2")])
        choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: FakeHostConfig(), style: .default, rootView: FakeRootView())
        
        let button1 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.first as? ACRChoiceButton)
        let button2 = try XCTUnwrap(choiceSetView.stackview.arrangedSubviews.last as? ACRChoiceButton)
        
        XCTAssertEqual(button1.accessibilityRole(), .checkBox)
        XCTAssertEqual(button1.accessibilityLabel(), "Button1")
        XCTAssertEqual(button2.accessibilityLabel(), "Button2")
    }
}
