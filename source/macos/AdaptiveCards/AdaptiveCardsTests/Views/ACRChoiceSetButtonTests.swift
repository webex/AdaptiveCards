@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRChoiceSetButtontests: XCTestCase {
    private var choiceCheckBoxButtonView: ACRChoiceButton!
    private var choiceRadioButtonView: ACRChoiceButton!
    private var renderConfig: RenderConfig!
    private var choiceSetInput: FakeChoiceSetInput!
    
    override func setUp() {
        super.setUp()
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: .default,checkBoxButtonConfig: setupCheckBoxButton(), radioButtonConfig: setupRadioButton(), localisedStringConfig: nil)
        choiceSetInput = FakeChoiceSetInput()
        choiceCheckBoxButtonView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .switch, element: choiceSetInput, title: "Test")
//        choiceCheckBoxButtonView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .switch)
        choiceRadioButtonView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .radio, element: choiceSetInput, title: "Test")
    }
    
    func testCheckBoxButtonClick() {
        XCTAssertEqual(choiceCheckBoxButtonView.state, .off)
        choiceCheckBoxButtonView.button.performClick(nil)
        XCTAssertEqual(choiceCheckBoxButtonView.state, .on)
        choiceCheckBoxButtonView.button.performClick(nil)
        XCTAssertEqual(choiceCheckBoxButtonView.state, .off)
    }
    
    func testRadioButtonLabelClick() {
        XCTAssertEqual(choiceRadioButtonView.state, .off)
        choiceRadioButtonView.mouseDown(with: NSEvent())
        XCTAssertEqual(choiceRadioButtonView.state, .on)
        choiceRadioButtonView.mouseDown(with: NSEvent())
        XCTAssertEqual(choiceRadioButtonView.state, .on)
    }
    
    func testCheckBoxButtonLabelClick() {
        XCTAssertEqual(choiceCheckBoxButtonView.state, .off)
        choiceCheckBoxButtonView.mouseDown(with: NSEvent())
        XCTAssertEqual(choiceCheckBoxButtonView.state, .on)
        choiceCheckBoxButtonView.mouseDown(with: NSEvent())
        XCTAssertEqual(choiceCheckBoxButtonView.state, .off)
    }
    
    func testCheckBoxButtonImagesOff() {
        XCTAssertNotNil(choiceCheckBoxButtonView.button.image)
        XCTAssertNotNil(choiceCheckBoxButtonView.button.alternateImage)
        XCTAssertEqual(choiceCheckBoxButtonView.button.image, renderConfig.checkBoxButtonConfig?.normalIcon)
        XCTAssertEqual(choiceCheckBoxButtonView.button.alternateImage, renderConfig.checkBoxButtonConfig?.highlightedIcon)
    }
    
    func testCheckBoxButtonImagesOn() {
        choiceCheckBoxButtonView.state = .on
        XCTAssertNotNil(choiceCheckBoxButtonView.button.image)
        XCTAssertNotNil(choiceCheckBoxButtonView.button.alternateImage)
        XCTAssertEqual(choiceCheckBoxButtonView.button.image, renderConfig.checkBoxButtonConfig?.selectedHighlightedIcon)
        XCTAssertEqual(choiceCheckBoxButtonView.button.alternateImage, renderConfig.checkBoxButtonConfig?.selectedIcon)
    }

    func testRadioButtonImagesOff() {
        XCTAssertNotNil(choiceRadioButtonView.button.image)
        XCTAssertNotNil(choiceRadioButtonView.button.alternateImage)
        XCTAssertEqual(choiceRadioButtonView.button.image, renderConfig.radioButtonConfig?.normalIcon)
        XCTAssertEqual(choiceRadioButtonView.button.alternateImage, renderConfig.radioButtonConfig?.highlightedIcon)
    }
    
    func testRadioButtonImagesOn() {
        choiceRadioButtonView.state = .on
        XCTAssertNotNil(choiceRadioButtonView.button.image)
        XCTAssertNotNil(choiceRadioButtonView.button.alternateImage)
        XCTAssertEqual(choiceRadioButtonView.button.image, renderConfig.radioButtonConfig?.selectedHighlightedIcon)
        XCTAssertEqual(choiceRadioButtonView.button.alternateImage, renderConfig.radioButtonConfig?.selectedIcon)
    }
    
    func testRadioButtonWithoutImages() {
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        choiceRadioButtonView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .radio, element: choiceSetInput, title: "Test")
        let defaultRadioButton = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
        
        XCTAssertEqual(choiceRadioButtonView.button.image, defaultRadioButton.image)
        XCTAssertEqual(choiceRadioButtonView.button.alternateImage, defaultRadioButton.alternateImage)
    }
    
    func testCheckBoxButtonWithoutImages() {
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        choiceCheckBoxButtonView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .switch, element: choiceSetInput, title: "Test")
        let defaultCheckBoxButton = NSButton(checkboxWithTitle: "", target: nil, action: nil)
        
        XCTAssertEqual(choiceCheckBoxButtonView.button.image, defaultCheckBoxButton.image)
        XCTAssertEqual(choiceCheckBoxButtonView.button.alternateImage, defaultCheckBoxButton.alternateImage)
    }
    
    func testElementSpacing() {
        let elementSpacing = choiceRadioButtonView.fittingSize.width - (choiceRadioButtonView.buttonLabelField.fittingSize.width + choiceRadioButtonView.button.fittingSize.width)
        XCTAssertEqual(renderConfig.checkBoxButtonConfig?.elementSpacing, elementSpacing)
    }
    
    func testChoiceButtonInChoiceSetAccessibility() {
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        choiceSetInput = .make(isRequired: true, label: "Test Label")
        choiceCheckBoxButtonView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .switch, element: choiceSetInput, title: "Button Title")
        XCTAssertEqual(choiceCheckBoxButtonView.accessibilityLabel(), "Test Label, Button Title")
    }
    
    func testChoiceButtonInInputToggleAccessibility() {
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let toggleInput = FakeInputToggle.make(title: "Button Title", isRequired: true, label: "Test Label")
        let inputToggleView = ACRChoiceButton(renderConfig: renderConfig, buttonType: .switch, element: toggleInput)
        XCTAssertEqual(inputToggleView.accessibilityLabel(), "Test Label, Button Title")
    }
    
    private func setupRadioButton() -> ChoiceSetButtonConfig {
        let onHoverIcon = NSImage()
        let offHoverIcon = NSImage()
        let onIcon = NSImage()
        let offIcon = NSImage()
        
        return ChoiceSetButtonConfig(selectedIcon: onIcon, normalIcon: offIcon, selectedHighlightedIcon: onHoverIcon, highlightedIcon: offHoverIcon, elementSpacing: 12)
    }
    
    private func setupCheckBoxButton() -> ChoiceSetButtonConfig {
        let onHoverIcon = NSImage()
        let offHoverIcon = NSImage()
        let onIcon = NSImage()
        let offIcon = NSImage()
        
        return ChoiceSetButtonConfig(selectedIcon: onIcon, normalIcon: offIcon, selectedHighlightedIcon: onHoverIcon, highlightedIcon: offHoverIcon, elementSpacing: 12)
    }
}
