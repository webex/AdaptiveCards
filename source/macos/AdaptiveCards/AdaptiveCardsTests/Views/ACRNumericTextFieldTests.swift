@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRNumericTestFieldTests: XCTestCase {
    private var numericView: ACRNumericTextField!
    private var config: RenderConfig!
    override func setUp() {
        super.setUp()
        let inputFieldConfig = InputFieldConfig(height: 26, leftPadding: 8, rightPadding: 8, yPadding: 0, focusRingCornerRadius: 8, borderWidth: 0.3, wantsClearButton: true, clearButtonImage: NSImage(), calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 14), highlightedColor: NSColor(red: 0, green: 0, blue: 0, alpha: 0.11), backgroundColor: NSColor(red: 1, green: 1, blue: 1, alpha: 1), borderColor: .black, activeBorderColor: .black, placeholderTextColor: NSColor.placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 5, left: 10, bottom: 0, right: 0), errorMessageConfig: ErrorMessageConfig(errorMessageFont: .systemFont(ofSize: 10), errorMessageTextColor: .systemRed, errorBorderColor: .systemRed, errorBackgroundColor: NSColor.systemRed.withAlphaComponent(0.1)))
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: inputFieldConfig, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        numericView = ACRNumericTextField(config: .default)
        numericView.inputString = "20"
        numericView.maxValue = Double.greatestFiniteMagnitude
        numericView.minValue = -Double.greatestFiniteMagnitude
    }
    
    func testInvalidCharacterInputEnd() {
        numericView.textField.stringValue = "20a"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.inputString, "20")
    }
    
    func testInvalidCharacterInputMiddle() {
        numericView.textField.stringValue = "2a0"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.inputString, "20")
    }
    
    func testInvalidCharacterInputFirst() {
        numericView.textField.stringValue = "a20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.inputString, "20")
    }
    
    func testValidCharacterInput() {
        numericView.textField.stringValue = "250"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.inputString, "250")
    }
    
    func testDecimalPointEntered() {
        numericView.textField.stringValue = "2.50"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.inputString, "2.50")
    }
    
    func testNegativeNumberInputTest() {
        numericView.textField.stringValue = "-20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.inputString, "-20")
    }
    
    func testIsRequiredValidation() {
        numericView.isRequired = true
        
        numericView.textField.stringValue = ""
        XCTAssertFalse(numericView.isValid)
        numericView.textField.stringValue = "1"
        XCTAssertTrue(numericView.isValid)
    }
    
    func testInputRangeValidation() {
        numericView.maxValue = 20
        numericView.minValue = 0
        
        numericView.textField.stringValue = ""
        XCTAssertTrue(numericView.isValid)
        numericView.textField.stringValue = "21"
        XCTAssertFalse(numericView.isValid)
        numericView.textField.stringValue = "-1"
        XCTAssertFalse(numericView.isValid)
        numericView.textField.stringValue = "10"
        XCTAssertTrue(numericView.isValid)
    }
    
    func testInputRangeAndIsRequiredValidation() {
        numericView.isRequired = true
        numericView.maxValue = 20
        numericView.minValue = 0
        
        numericView.textField.stringValue = ""
        XCTAssertFalse(numericView.isValid)
        numericView.textField.stringValue = "21"
        XCTAssertFalse(numericView.isValid)
        numericView.textField.stringValue = "-1"
        XCTAssertFalse(numericView.isValid)
        numericView.textField.stringValue = "10"
        XCTAssertTrue(numericView.isValid)
    }
}
