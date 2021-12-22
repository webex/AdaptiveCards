@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRInputTextViewTests: XCTestCase {
    private var textInputView: ACRTextInputView!
    private var config: RenderConfig!
    
    override func setUp() {
        super.setUp()
        let inputFieldConfig = InputFieldConfig(height: 26, leftPadding: 8, rightPadding: 8, yPadding: 0, focusRingCornerRadius: 8, borderWidth: 0.3, wantsClearButton: true, clearButtonImage: NSImage(), calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 14), highlightedColor: NSColor(red: 0, green: 0, blue: 0, alpha: 0.11), backgroundColor: NSColor(red: 1, green: 1, blue: 1, alpha: 1), borderColor: .black, activeBorderColor: .black, placeholderTextColor: NSColor.placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 5, left: 10, bottom: 0, right: 0), errorMessageConfig: InputFieldConfig.ErrorMessageConfig.default)
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: inputFieldConfig, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        textInputView = ACRTextInputView(config: config)
    }
    
    func testClearButtonAbsentDefault() {
        XCTAssertTrue(textInputView.clearButton.isHidden)
    }
    
    func testClearButtonPresent() {
        textInputView.attributedStringValue = NSAttributedString(string: "Test")
        XCTAssertFalse(textInputView.clearButton.isHidden)
    }
    
    func testClearButtonPerformsDelete() {
        textInputView.attributedStringValue = NSAttributedString(string: "Test")
        XCTAssertFalse(textInputView.clearButton.isHidden)
        textInputView.clearButton.performClick()
        XCTAssertTrue(textInputView.clearButton.isHidden)
        XCTAssertEqual(textInputView.stringValue, "")
    }
    
    func testTextFieldIsRequiredValidation() {
        textInputView.isRequired = true
        textInputView.stringValue = ""
        XCTAssertFalse(textInputView.isValid)
        textInputView.stringValue = "s"
        XCTAssertTrue(textInputView.isValid)
    }
    
    func testTextFieldRegexValidation() {
        textInputView.isRequired = false
        // regex for input of a single digit
        textInputView.regex = "^[0-9]{1}$"
        
        textInputView.stringValue = ""
        XCTAssertTrue(textInputView.isValid)
        textInputView.stringValue = "a"
        XCTAssertFalse(textInputView.isValid)
        textInputView.stringValue = "12"
        XCTAssertFalse(textInputView.isValid)
        textInputView.stringValue = "5"
        XCTAssertTrue(textInputView.isValid)
    }
    
    func testTextFieldRegexAndIsRequiredValidation() {
        textInputView.isRequired = true
        // regex for input of a single digit
        textInputView.regex = "^[0-9]{1}$"
        
        textInputView.stringValue = ""
        XCTAssertFalse(textInputView.isValid)
        textInputView.stringValue = "a"
        XCTAssertFalse(textInputView.isValid)
        textInputView.stringValue = "12"
        XCTAssertFalse(textInputView.isValid)
        textInputView.stringValue = "5"
        XCTAssertTrue(textInputView.isValid)
    }
    
    func testSetErrorColors() {
        textInputView.showError()
        XCTAssertEqual(textInputView.layer?.borderColor, config.inputFieldConfig.errorMessageConfig.borderColor.cgColor)
        XCTAssertEqual(textInputView.layer?.backgroundColor, config.inputFieldConfig.errorMessageConfig.backgroundColor.cgColor)
    }
}
