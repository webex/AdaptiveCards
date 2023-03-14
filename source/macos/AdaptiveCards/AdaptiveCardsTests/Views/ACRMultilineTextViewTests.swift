@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRMultilineTextViewTests: XCTestCase {
    private var multiLineTextView: ACRMultilineTextView!
    private var renderConfig: RenderConfig!
    private var inputElement: FakeInputText!
    
    override func setUp() {
        super.setUp()
        renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: setupInputField(), checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        inputElement = .make()
        multiLineTextView = ACRMultilineTextView.init(config: renderConfig, inputElement: inputElement)
    }
    
    func testACRMultilineInputTextViewInitsWithoutError() {
        //Test default initialsier
        let textInputView = ACRMultilineTextView.init(config: renderConfig, inputElement: inputElement)
        XCTAssertNotNil(textInputView)
    }
    
    func testLeftPadding() {
        XCTAssertEqual(multiLineTextView.textView.textContainerInset.width, renderConfig.inputFieldConfig.multilineFieldInsets.left)
    }
    
    func testTopPadding() {
        XCTAssertEqual(multiLineTextView.textView.textContainerInset.height, renderConfig.inputFieldConfig.multilineFieldInsets.top)
    }
    
    func testInitialBackgroundColor() {
        XCTAssertEqual(multiLineTextView.textView.backgroundColor, renderConfig.inputFieldConfig.backgroundColor)
    }
    
    func testHoverBackgroundColor() {
        // to check if appearance is updated
        multiLineTextView.textView.backgroundColor = NSColor.black
        multiLineTextView.mouseEntered(with: NSEvent())
        XCTAssertEqual(multiLineTextView.textView.backgroundColor, renderConfig.inputFieldConfig.backgroundColor)
    }
    
    func testHoverExitBackgroundColor() {
        multiLineTextView.mouseEntered(with: NSEvent())
        multiLineTextView.mouseExited(with: NSEvent())
        XCTAssertEqual(multiLineTextView.textView.backgroundColor, renderConfig.inputFieldConfig.backgroundColor)
    }
    
    func testBorderParameters() {
        XCTAssertEqual(multiLineTextView.layer?.borderWidth, renderConfig.inputFieldConfig.borderWidth)
        XCTAssertEqual(multiLineTextView.layer?.borderColor, renderConfig.inputFieldConfig.borderColor.cgColor)
    }
    
    func testFocusRingCornerRadius() {
        XCTAssertEqual(multiLineTextView.scrollView.focusRingCornerRadius, renderConfig.inputFieldConfig.focusRingCornerRadius)
    }
    
    func testHeightConstraint() {
        let textInputView = ACRMultilineTextView.init(config: renderConfig, inputElement: inputElement)
        XCTAssertNotNil(textInputView)
        XCTAssertNotNil(textInputView.scrollView.heightAnchor)
        XCTAssertNotNil(textInputView.scrollView.constraints.first { constraint in
            return constraint.relation == .equal && constraint.constant == 100.0
        })
        textInputView.heightType = .stretch
        XCTAssertNotNil(textInputView.scrollView.heightAnchor)
        XCTAssertNotNil(textInputView.scrollView.constraints.first { constraint in
            return constraint.relation == .greaterThanOrEqual && constraint.constant == 100.0 && constraint.isActive == true
        })
    }
    
    private func setupInputField() -> InputFieldConfig{
        let resourceImage = BundleUtils.getImage("warning-badge-filled-light", ofType: "png")
        return InputFieldConfig(height: 0, leftPadding: 12, rightPadding: 8, yPadding: 0, focusRingCornerRadius: 8, borderWidth: 0.3, wantsClearButton: false, clearButtonImage: nil, calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 14), highlightedColor: NSColor(red: 1, green: 1, blue: 1, alpha: 0.11), backgroundColor: NSColor(red: 0.148, green: 0.148, blue: 0.148, alpha: 1), borderColor: NSColor(red: 1, green: 1, blue: 1, alpha: 0.9), activeBorderColor: NSColor(red: 1, green: 1, blue: 1, alpha: 0.9), placeholderTextColor: NSColor.placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 5, left: 10, bottom: 0, right: 0), errorStateConfig: InputFieldConfig.ErrorStateConfig.default, warningBadgeImage: resourceImage)
    }
}
