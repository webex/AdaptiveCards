@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ColumnRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var column: FakeColumn!
    private var columnRenderer: ColumnRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        column = .make()
        columnRenderer = ColumnRenderer()
    }
    
    func testAutoWidth() {
        column = .make(width: "auto")
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.columnWidth, .auto)
        XCTAssertEqual(columnView.contentHuggingPriority(for: .horizontal), ColumnWidth.auto.huggingPriority)
        XCTAssertEqual(columnView.contentCompressionResistancePriority(for: .horizontal), .defaultHigh)
    }
    
    func testStretchWidth() {
        column = .make(width: "stretch")
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.columnWidth, .stretch)
        XCTAssertEqual(columnView.contentHuggingPriority(for: .horizontal), ColumnWidth.stretch.huggingPriority)
        XCTAssertEqual(columnView.contentCompressionResistancePriority(for: .horizontal), .defaultLow)
    }
    
    func testWeightedWidth() {
        column = .make(width: "20")
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.columnWidth, .weighted(20))
    }
    
    func testConstantWidth() {
        column = .make(width: "0", pixelWidth: 200)
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.columnWidth, .fixed(200))
        XCTAssertEqual(columnView.fittingSize.width, 200)
    }
    
    func testMinHeight() {
        column = .make(minHeight: 200)
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.fittingSize.height, 200)
    }
    
    func testVerticalContentAlignment() {
        // since we removed padding view all together and replaced with lastPadding but use paddingView for vertical content alignment this has changed
        column = .make(items: [FakeTextBlock.make()], verticalContentAlignment: .center)
        var columnView = renderColumnView()
        XCTAssertEqual(columnView.arrangedSubviews.count, 4)
        
        column = .make(items: [FakeTextBlock.make()], verticalContentAlignment: .bottom)
        columnView = renderColumnView()
        XCTAssertEqual(columnView.arrangedSubviews.count, 3)
        
        column = .make(items: [FakeTextBlock.make(heightType: .stretch)], verticalContentAlignment: .center)
        columnView = renderColumnView()
        XCTAssertTrue(columnView.arrangedSubviews.last?.isHidden ?? false)
        XCTAssertEqual(columnView.arrangedSubviews.count, 2)
    }
    
    func testSelectActionTargetIsSet() {
        var columnView: ACRColumnView!
        
        column = .make(selectAction: FakeSubmitAction.make())
        columnView = renderColumnView()
        
        XCTAssertNotNil(columnView.target)
        XCTAssertTrue(columnView.target is ActionSubmitTarget)
        
        column = .make(selectAction: FakeOpenURLAction.make())
        columnView = renderColumnView()
        
        XCTAssertNotNil(columnView.target)
        XCTAssertTrue(columnView.target is ActionOpenURLTarget)
        
        column = .make(selectAction: FakeToggleVisibilityAction.make())
        columnView = renderColumnView()
        
        XCTAssertNotNil(columnView.target)
        XCTAssertTrue(columnView.target is ActionToggleVisibilityTarget)
        
        // ShowCard Action is not available as a SelectAction
        column = .make(selectAction: FakeShowCardAction.make())
        columnView = renderColumnView()
    
        XCTAssertNil(columnView.target)
    }
    
    func testRendersItems() {
        column = .make(items: [FakeTextBlock.make(), FakeInputNumber.make()])
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.arrangedSubviews.count, 4)
    }
    
    func testDateFieldWidth() {
        column = .make(items: [FakeInputDate.make()])
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.minWidthConstraint.constant, 100)
    }
    
    func testIntrinsicContentSizeWithHiddenInputElements() {
        let inputField = FakeInputText.make(id: "id", isRequired: true, errorMessage: "error message", label: "label message", separator: false, heightType: .auto, isVisible: false)
        column = FakeColumn.make(isVisible: true, items: [inputField])
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.intrinsicContentSize, .zero)
    }
    
    func testPaddingWhenContainerEmptyWithoutStyle() {
        // No padding added
        column = FakeColumn.make(isVisible: true, style: .none)
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.stackView.arrangedSubviews.count, 1)
    }
    
    func testColumnWithHeight() {
        column = FakeColumn.make(isVisible: true, style: .accent, height: .stretch)
        let columnView = renderColumnView()
        XCTAssertEqual(columnView.stackView.arrangedSubviews.count, 1)
    }
    
    private func renderColumnView() -> ACRColumnView {
        let view = columnRenderer.render(element: column, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRContentStackView)
        guard let columnView = view as? ACRColumnView else { fatalError() }
        return columnView
    }
}
