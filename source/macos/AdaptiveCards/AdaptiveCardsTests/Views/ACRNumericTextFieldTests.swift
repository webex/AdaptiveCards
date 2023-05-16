@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRNumericTestFieldTests: XCTestCase {
    private var numericView: ACRNumericTextField!
    private var config: RenderConfig!
    private var inputElement: FakeInputNumber!
    override func setUp() {
        super.setUp()
        inputElement = FakeInputNumber.make()
        numericView = ACRNumericTextField(config: .default, inputElement: inputElement)
        numericView.value = "20"
        numericView.maxValue = Double.greatestFiniteMagnitude
        numericView.minValue = -Double.greatestFiniteMagnitude
    }
    
    func testACRNumericTextFieldInitsWithoutError() {
        //Test default initialsier
        let numberInputView = ACRNumericTextField(config: .default, inputElement: inputElement)
        XCTAssertNotNil(numberInputView)
    }
    
    func testInvalidCharacterInputEnd() {
        numericView.textField.stringValue = "20a"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "20")
    }
    
    func testInvalidCharacterInputMiddle() {
        numericView.textField.stringValue = "2a0"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "20")
    }
    
    func testInvalidCharacterInputFirst() {
        numericView.textField.stringValue = "a20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "20")
    }
    
    func testValidCharacterInput() {
        numericView.textField.stringValue = "250"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "250")
    }
    
    func testDecimalPointEntered() {
        numericView.textField.stringValue = "2.50"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "2.5")
    }
    
    func testNegativeNumberInputTest() {
        numericView.textField.stringValue = "-20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "-20")
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
    
    func testExponentPointEntered() {
        numericView.textField.stringValue = "2.50e20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "2.5e+20")
    }
    
    func testnegativeExponentPointEntered() {
        numericView.textField.stringValue = "2.50e-20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "2.5e-20")
    }
    
    func testNegativeNumberExponentPointEntered() {
        numericView.textField.stringValue = "-2.50e20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "-2.5e+20")
    }
    
    func testNegativeNumberNegativeExponentPointEntered() {
        numericView.textField.stringValue = "-2e-20"
        let object = Notification(name: NSNotification.Name.init("NSControlTextDidChangeNotification"), object: numericView.textField)
        numericView.controlTextDidChange(object)
        XCTAssertEqual(numericView.value, "-2e-20")
    }
    
    func testAccessibilityTitle1_2() {
        numericView.attributedPlaceholder = NSAttributedString(string: "Placeholder")
        XCTAssertNil(numericView.accessibilityTitle())
        numericView.value = "ABC"
        XCTAssertNil(numericView.accessibilityTitle())
    }
    
    func testAccessibilityTitle1_3() {
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        numericView = ACRNumericTextField(config: config, inputElement: inputElement)
        numericView.attributedPlaceholder = NSAttributedString(string: "Placeholder")
        
        numericView.value = ""
        XCTAssertEqual(numericView.accessibilityTitle(), "Placeholder")
        
        numericView.value = "ABC"
        XCTAssertEqual(numericView.accessibilityTitle(), "ABC")
        
        numericView.showError()
        XCTAssertEqual(numericView.accessibilityTitle(), "Error, ABC")
        
        numericView.textField.hideError()
        XCTAssertEqual(numericView.accessibilityTitle(), "ABC")
    }
}
