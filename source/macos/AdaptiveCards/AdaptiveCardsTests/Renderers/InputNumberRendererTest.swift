@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest
import Carbon.HIToolbox.Events

class InputNumberRendererTest: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var inputNumber: FakeInputNumber!
    private var inputNumberRenderer: InputNumberRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        inputNumber = .make()
        inputNumberRenderer = InputNumberRenderer()
    }
    
    func testRendererSetsValue() {
        let val: NSNumber = 25
        inputNumber = .make(value: val)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.inputValue, val.doubleValue)
    }
    
    func testRendererSetsPlaceholder() {
        let placeholderString: String = "Sample Placeholder"
        inputNumber = .make(placeholder: placeholderString)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.placeholder, placeholderString)
    }
    
    func testRendererIfValueIsVisible() {
        let placeholderString: String = "Sample Placeholder"
        let val: NSNumber = 23.4
        inputNumber = .make(value: val, placeholder: placeholderString)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.inputValue, val.doubleValue)
    }
    
    func testRendererIfInputFieldIsHidden() {
        inputNumber = .make(visible: false)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.isHidden, true)
    }
    
    func testRendererForMinValue() {
        let minVal: NSNumber = -5
        let val: NSNumber = 20
        inputNumber = .make(value: val, min: minVal)
        
        let inputNumberField = renderNumberInput()
        // min value is equal to stepper min value
        XCTAssertEqual(inputNumberField.minValue, minVal.doubleValue)
        // min value is not equal to input value
        XCTAssertTrue(inputNumberField.inputValue != minVal.doubleValue)
    }
    
    func testRendererForMaxValue() {
        let maxValue: NSNumber = 100
        let val: NSNumber = 20
        inputNumber = .make(value: val, max: maxValue)
        
        let inputNumberField = renderNumberInput()
        // max value is equal to stepper max value
        XCTAssertEqual(inputNumberField.maxValue, maxValue.doubleValue)
        // max value is not equal to input value
        XCTAssertTrue(inputNumberField.inputValue != maxValue.doubleValue)
    }
    
    func testRendererIfTruncatesExtraZeros() {
        let val: NSNumber = 20.00
        inputNumber = .make(value: val)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.inputString, "20")
        XCTAssertEqual(inputNumberField.inputValue, 20)
        XCTAssertEqual(inputNumberField.value, "20")
    }
    
    func testclearButtonHiddenByDefault() {
        inputNumber = .make(value: nil)
        let inputNumberField = renderNumberInput()
        XCTAssertTrue(inputNumberField.textField.clearButton.isHidden)
    }
    
    func testClearButtonVisibleWhenValuePresent() {
        inputNumber = .make(value : 0)
        let inputNumberField = renderNumberInput()
        XCTAssertFalse(inputNumberField.textField.clearButton.isHidden)
    }
    
    func testClearButtonClearsValue() {
        inputNumber = .make(value : 0)
        
        let inputNumberField = renderNumberInput()
        XCTAssertFalse(inputNumberField.textField.clearButton.isHidden)
        XCTAssertEqual(inputNumberField.textField.stringValue, "0")
        XCTAssertEqual(inputNumberField.inputString, "0")
        XCTAssertEqual(inputNumberField.inputValue, 0.0)
        XCTAssertEqual(inputNumberField.value, "0")
        
        inputNumberField.textField.clearButton.performClick()
        
        XCTAssertTrue(inputNumberField.textField.clearButton.isHidden)
        XCTAssertEqual(inputNumberField.textField.stringValue, "")
        XCTAssertEqual(inputNumberField.inputString, "")
        XCTAssertEqual(inputNumberField.inputValue, 0.0)
        XCTAssertEqual(inputNumberField.value, "0")
    }
    
    func testOnlyDecimalPointReturnsZero() {
        let inputNumberField = renderNumberInput()
        inputNumberField.inputString = "."
        
        XCTAssertEqual(inputNumberField.value, "0")
        XCTAssertEqual(inputNumberField.inputString, "0")
        XCTAssertEqual(inputNumberField.inputValue, 0.0)
    }
    
    func testDecimalPointtAtEndReturnsTheInteger() {
        let inputNumberField = renderNumberInput()
        inputNumberField.inputString = "2."
        
        XCTAssertEqual(inputNumberField.value, "2")
        XCTAssertEqual(inputNumberField.inputString, "2")
        XCTAssertEqual(inputNumberField.inputValue, 2.0)
    }
    
    func testDecimalValuesReturnedWhenStored() {
        inputNumber = .make(value : 12.3)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.value, "12.3")
        XCTAssertEqual(inputNumberField.inputString, "12.3")
        XCTAssertEqual(inputNumberField.inputValue, 12.3)
    }
    
    func testNegativeValuesReturnedWhenStored() {
        inputNumber = .make(value : -12.3)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.value, "-12.3")
        XCTAssertEqual(inputNumberField.inputString, "-12.3")
        XCTAssertEqual(inputNumberField.inputValue, -12.3)
    }
    
    func testAccessibilityValueSet() {
        let val: NSNumber = 20.00
        inputNumber = .make(value: val)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.inputString, "20")
        XCTAssertEqual(inputNumberField.accessibilityChildren()?.count, 2)
        XCTAssertEqual(inputNumberField.textField.accessibilityTitle(), "Input Number")
        XCTAssertEqual(inputNumberField.textField.accessibilityValue(), "20")
        // Checking Stepper Accessibility Value here
        guard let stepper = getAssociatedStepper(of: inputNumberField), let stepperAccessibilityValue = stepper.accessibilityValue() as? String else { return XCTFail() }
        XCTAssertEqual(stepperAccessibilityValue, "20")
    }
    
    func testAccessibilityUpAndDownArrows() {
        let val: NSNumber = 20.00
        inputNumber = .make(value: val)
        
        let inputNumberField = renderNumberInput()
        XCTAssertEqual(inputNumberField.inputString, "20")
        XCTAssertEqual(inputNumberField.inputValue, 20)
        XCTAssertEqual(inputNumberField.value, "20")
        
        keyPressed(for: UInt16(kVK_UpArrow), on: inputNumberField)
        XCTAssertEqual(inputNumberField.inputString, "21")
        XCTAssertEqual(inputNumberField.inputValue, 21.0)
        XCTAssertEqual(inputNumberField.value, "21")
        
        keyPressed(for: UInt16(kVK_DownArrow), on: inputNumberField)
        XCTAssertEqual(inputNumberField.inputString, "20")
        XCTAssertEqual(inputNumberField.inputValue, 20)
        XCTAssertEqual(inputNumberField.value, "20")
    }
       
    private func renderNumberInput() -> ACRNumericTextField {
        let view = inputNumberRenderer.render(element: inputNumber, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRNumericTextField)
        guard let inputNumber = view as? ACRNumericTextField else { fatalError() }
        return inputNumber
    }
    
    private func getAssociatedStepper(of numericField: ACRNumericTextField) -> NSStepper? {
        guard let stepper = numericField.subviews.last as? NSStepper else { return nil }
        return stepper
    }
    
    private func keyPressed(for keyCode: UInt16, on numericView: ACRNumericTextField) {
        let event = NSEvent.keyEvent(with: NSEvent.EventType.keyDown, location: numericView.frame.origin, modifierFlags: [], timestamp: 0, windowNumber: 0, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: false, keyCode: keyCode)
        numericView.keyDown(with: event!)
    }
}

