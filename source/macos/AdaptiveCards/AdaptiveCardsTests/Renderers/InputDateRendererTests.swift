@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class InputDateRendererTest: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var inputDate: FakeInputDate!
    private var inputDateRenderer: InputDateRenderer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        inputDate = .make()
        inputDateRenderer = InputDateRenderer()
    }
    
    func testHeightProperty() {
        let val: String = "2000-10-12"
        
        inputDate = .make(value: val, heightType: .auto)
        var inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.contentStackView.arrangedSubviews.count, 1)
        XCTAssertNil(inputDateField.contentStackView.arrangedSubviews.last as? StretchableView)
        
        inputDate = .make(value: val, heightType: .stretch)
        inputDateField = renderDateInput()
        
        XCTAssertEqual(inputDateField.contentStackView.arrangedSubviews.count, 2)
        XCTAssertNotNil(inputDateField.contentStackView.arrangedSubviews.last as? StretchableView)
        guard let stretchView = inputDateField.contentStackView.arrangedSubviews.last as? StretchableView else { return XCTFail() }
        XCTAssertEqual(stretchView.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testRendererSetsValue() {
        let val: String = "2000-10-12"
        inputDate = .make(value: val)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.datePickerCalendar.dateValue, dateFormatter.date(from: val))
        XCTAssertEqual(inputDateField.datePickerTextfield.dateValue, dateFormatter.date(from: val))
        XCTAssertEqual(inputDateField.dateValue, val)
    }

    func testRendererSetsPlaceholder() {
        let placeholderString: String = "Sample Placeholder"
        inputDate = .make(placeholder: placeholderString)

        let inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.placeholder, placeholderString)
    }

    func testRendererForMinValue() {
        let minVal: String = "1999-03-23"
        inputDate = .make(min: minVal)

        let inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.minDateValue, minVal)
    }

    func testRendererForMaxValue() {
        let maxValue: String = "2022-02-20"
        inputDate = .make(max: maxValue)

        let inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.maxDateValue, maxValue)
    }
    
    func testRendererForIsRequired() {
        inputDate = .make(isRequired: true)
        
        let inputDateField = renderDateInput()
        XCTAssertTrue(inputDateField.isRequired)
    }
    
    func testClearsText() {
        let val: String = "2000-11-23"
        inputDate = .make(value: val)

        let inputDateField = renderDateInput()
        inputDateField.textField.clearButton.performClick()
        XCTAssertEqual(inputDateField.textField.stringValue, "")
        XCTAssertNil(inputDateField.dateValue)
        XCTAssertTrue(inputDateField.textField.clearButton.isHidden)
    }
    
    func testClearButtonHiddenWithPlaceholder() {
        let placeholderString: String = "Sample Placeholder"
        inputDate = .make(placeholder: placeholderString)

        let inputDateField = renderDateInput()
        XCTAssertTrue(inputDateField.textField.clearButton.isHidden)
    }
    
    func testClearButtonHiddenWithNoText() {
        inputDate = .make()
        
        let inputDateField = renderDateInput()
        XCTAssertTrue(inputDateField.textField.clearButton.isHidden)
    }
    
    func testClearButtonVisibleWithText() {
        let val: String = "2000-02-10"
        inputDate = .make(value: val)
        
        let inputDateField = renderDateInput()
        XCTAssertFalse(inputDateField.textField.clearButton.isHidden)
    }
    
    func testValueShownOnlyForRightInputFormat() {
        let val: String = "12/10/2000"
        inputDate = .make(value: val)

        let inputDateField = renderDateInput()
        XCTAssertNil(inputDateField.dateValue)
        XCTAssertEqual(inputDateField.textField.stringValue, "")
    }
    
    func testCurrentDateInPopOverDefault() {
        inputDate = .make()
        
        let inputDateField = renderDateInput()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        XCTAssertEqual(dateFormatter.string(from: inputDateField.datePickerCalendar.dateValue), dateFormatter.string(from: Date()))
        XCTAssertEqual(dateFormatter.string(from: inputDateField.datePickerTextfield.dateValue), dateFormatter.string(from: Date()))
    }
    
    func testAccessbilityValueIsSet() {
        let val: String = "2000-02-10"
        inputDate = .make(value: val)
        
        let inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.accessibilityRoleDescription(), "Date Picker")
        XCTAssertEqual(inputDateField.iconButton.accessibilityRoleDescription(), "Date Picker Button")
        XCTAssertEqual(inputDateField.textField.accessibilityValue(), "10-Feb-2000")
    }
    
    func testAccessibilityLabelV1_3() {
        inputDate = .make()
        
        let inputDateField = renderDateInputV1_3()
        XCTAssertEqual(inputDateField.accessibilityLabel(), "")
        
        inputDateField.placeholder = "Enter Date"
        XCTAssertEqual(inputDateField.accessibilityLabel(), "Enter Date")
        
        inputDateField.textField.stringValue = "10-Feb-2000"
        XCTAssertEqual(inputDateField.accessibilityLabel(), "10-Feb-2000")
        
        inputDateField.textField.showError()
        XCTAssertEqual(inputDateField.accessibilityLabel(), "Error, 10-Feb-2000")
        
        inputDateField.textField.hideError()
        XCTAssertEqual(inputDateField.accessibilityLabel(), "10-Feb-2000")
    }
    
    func testPopoverCalendarAccessibility() {
        inputDate = .make()
        
        let inputDateField = renderDateInput()
        XCTAssertEqual(inputDateField.datePickerCalendar.accessibilityRole(), .none)
    }

    private func renderDateInput() -> ACRDateField {
        let view = inputDateRenderer.render(element: inputDate, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)

        XCTAssertTrue(view is ACRDateField)
        guard let inputDate = view as? ACRDateField else { fatalError() }
        return inputDate
    }
    
    private func renderDateInputV1_3() -> ACRDateField {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: .default)
        let view = inputDateRenderer.render(element: inputDate, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)

        XCTAssertTrue(view is ACRDateField)
        guard let inputDate = view as? ACRDateField else { fatalError() }
        return inputDate
    }
}
