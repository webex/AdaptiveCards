@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRTextFieldTests: XCTestCase {
    private var textField: ACRTextField!
    private var config: RenderConfig!
    private var delegate: FakeACRTextFieldDelegate!
    
    override func setUp() {
        super.setUp()
        let inputFieldConfig = InputFieldConfig(height: 26, leftPadding: 8, rightPadding: 8, yPadding: 0, focusRingCornerRadius: 8, borderWidth: 0.3, wantsClearButton: true, clearButtonImage: NSImage(), calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 14), highlightedColor: NSColor(red: 0, green: 0, blue: 0, alpha: 0.11), backgroundColor: NSColor(red: 1, green: 1, blue: 1, alpha: 1), borderColor: .black, activeBorderColor: .black, placeholderTextColor: NSColor.placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 5, left: 10, bottom: 0, right: 0), errorStateConfig: InputFieldConfig.ErrorStateConfig.default)
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: inputFieldConfig, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        textField = ACRTextField(textFieldWith: config, mode: .text, inputElement: nil)
        delegate = FakeACRTextFieldDelegate()
    }
    
    func testClearButtonAbsentDefault() {
        XCTAssertTrue(textField.clearButton.isHidden)
    }
    
    func testClearButtonPresent() {
        textField.attributedStringValue = NSAttributedString(string: "Test")
        XCTAssertFalse(textField.clearButton.isHidden)
    }
    
    func testNoClearButtonDefaultRenderConfig() {
        textField = ACRTextField(textFieldWith: .default, mode: .text, inputElement: nil)
        XCTAssertTrue(textField.subviews.isEmpty)
    }
    
    func testClearButtonPerformsDelete() {
        textField.attributedStringValue = NSAttributedString(string: "Test")
        XCTAssertFalse(textField.clearButton.isHidden)
        textField.clearButton.performClick()
        XCTAssertTrue(textField.clearButton.isHidden)
        XCTAssertEqual(textField.stringValue, "")
    }
    
    func testChangingRenderConfigChangesProperties() {
        let image = NSImage()
        let inputFieldConfig = InputFieldConfig(height: 40, leftPadding: 20, rightPadding: 20, yPadding: 0, focusRingCornerRadius: 10, borderWidth: 1, wantsClearButton: true, clearButtonImage: image, calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 10), highlightedColor: .blue, backgroundColor: .yellow, borderColor: .green, activeBorderColor: .black, placeholderTextColor: NSColor.placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 5, left: 10, bottom: 0, right: 0), errorStateConfig: InputFieldConfig.ErrorStateConfig.default)
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: inputFieldConfig, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        textField = ACRTextField(textFieldWith: config, mode: .text, inputElement: nil)
        XCTAssertEqual(textField.fittingSize.height, 40)
        XCTAssertEqual(textField.cell?.titleRect(forBounds: textField.bounds).origin.x, 20)
        XCTAssertEqual(textField.font, .systemFont(ofSize: 10))
        XCTAssertEqual(textField.clearButton.image?.hash, image.hash)
    }
    
    func testDateFieldContainsClearButtonAlways() {
        let textField = ACRTextField(textFieldWith: .default, mode: .dateTime, inputElement: nil)
        textField.stringValue = "test"
        XCTAssertEqual(textField.subviews.count, 1)
        XCTAssertEqual(textField.subviews[0].className, NSButtonWithImageSpacing().className)
        XCTAssertFalse(textField.clearButton.isHidden)
    }
    
    func testDateFieldLeftPadding() {
        let textField = ACRTextField(textFieldWith: .default, mode: .dateTime, inputElement: nil)
        // Left padding 20 for the image
        XCTAssertEqual(textField.cell?.titleRect(forBounds: textField.bounds).origin.x, 20)
    }
    
    func testAccessibilityTitle1_2() {
        textField.placeholderAttributedString = NSAttributedString(string: "Placeholder")
        XCTAssertNil(textField.accessibilityTitle())
        textField.stringValue = "ABC"
        XCTAssertNil(textField.accessibilityTitle())
    }
    
    func testAccessibilityTitle1_3() {
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        textField = ACRTextField(textFieldWith: config, mode: .text, inputElement: nil)
        textField.placeholderAttributedString = NSAttributedString(string: "Placeholder")
        
        textField.stringValue = ""
        XCTAssertEqual(textField.accessibilityTitle(), "Placeholder")
        
        textField.stringValue = "ABC"
        XCTAssertEqual(textField.accessibilityTitle(), "ABC")
        
        textField.showError()
        XCTAssertEqual(textField.accessibilityTitle(), "Error, ABC")
        
        textField.hideError()
        XCTAssertEqual(textField.accessibilityTitle(), "ABC")
    }
    
    func testTextFieldDelegateCalled() {
        textField.textFieldDelegate = delegate
        textField.stringValue = "test"
        XCTAssertFalse(delegate.isTextFieldCalled)
        textField.clearButton.performClick()
        XCTAssertTrue(delegate.isTextFieldCalled)
        XCTAssertEqual(delegate.textFieldStringValue, "")
    }
    
    func testSetErrorColors() {
        textField.showError()
        XCTAssertEqual(textField.layer?.borderColor, config.inputFieldConfig.errorStateConfig.borderColor.cgColor)
        XCTAssertEqual(textField.layer?.backgroundColor, config.inputFieldConfig.errorStateConfig.backgroundColor.cgColor)
    }
    
    func testBorderAndbgColorSet() {
        textField.drawFocusRingMask()
        XCTAssertEqual(textField.layer?.borderColor, config.inputFieldConfig.activeBorderColor.cgColor)
        XCTAssertEqual(textField.layer?.backgroundColor, config.inputFieldConfig.backgroundColor.cgColor)
        
        textField.layer?.backgroundColor = NSColor.black.cgColor
        textField.layer?.borderColor = NSColor.black.cgColor
        // check appearance is updated
        textField.mouseEntered(with: NSEvent())
        XCTAssertEqual(textField.layer?.borderColor, config.inputFieldConfig.borderColor.cgColor)
        XCTAssertEqual(textField.layer?.backgroundColor, config.inputFieldConfig.backgroundColor.cgColor)
        
        textField.layer?.backgroundColor = NSColor.black.cgColor
        textField.layer?.borderColor = NSColor.black.cgColor
        // check appearance is updated
        textField.mouseExited(with: NSEvent())
        XCTAssertEqual(textField.layer?.borderColor, config.inputFieldConfig.activeBorderColor.cgColor)
        XCTAssertEqual(textField.layer?.backgroundColor, config.inputFieldConfig.backgroundColor.cgColor)
    }
}

private class FakeACRTextFieldDelegate: ACRTextFieldDelegate {
    var isTextFieldCalled = false
    var textFieldStringValue: String?
    func acrTextFieldDidSelectClear(_ textField: ACRTextField) {
        isTextFieldCalled = true
        textFieldStringValue = textField.stringValue
    }
}
