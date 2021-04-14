@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class InputTimeRendererTest: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var inputTime: FakeInputTime!
    private var inputTimeRenderer: InputTimeRenderer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        inputTime = .make()
        inputTimeRenderer = InputTimeRenderer()
    }
    
    func testRendererSetsValue() {
        let value: String = "15:30"
        inputTime = .make(value: val)

        let inputTimeField = renderTimeInput()
        XCTAssertEqual(inputTimeField.dateValue, value)
    }

    func testRendererSetsPlaceholder() {
        let placeholderString: String = "Sample Placeholder"
        inputTime = .make(placeholder: placeholderString)

        let inputTimeField = renderTimeInput()
        XCTAssertEqual(inputTimeField.placeholder, placeholderString)
    }
    
    func testRendererForMinValue() {
        let minValue: String = "09:30"
        inputTime = .make(min: minVal)

        let inputTimeField = renderTimeInput()
        XCTAssertEqual(inputTimeField.minDateValue, minValue)
    }

    func testRendererForMaxValue() {
        let maxValue: String = "16:00"
        inputTime = .make(max: maxValue)

        let inputTimeField = renderTimeInput()
        XCTAssertEqual(inputTimeField.maxDateValue, maxValue)
    }

    private func renderTimeInput() -> ACRDateField {
        let view = inputTimeRenderer.render(element: inputTime, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)

        XCTAssertTrue(view is ACRDateField)
        guard let inputTime = view as? ACRDateField else { fatalError() }
        return inputTime
    }
}

