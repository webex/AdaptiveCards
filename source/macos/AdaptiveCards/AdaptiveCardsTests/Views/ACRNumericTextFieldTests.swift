@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRNumericTestFieldTests: XCTestCase {
    private var numericView: ACRNumericTextField!
    private var config: RenderConfig!
    override func setUp() {
        super.setUp()
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
