@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ColumnRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var columnRenderer: ColumnRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        columnRenderer = ColumnRenderer()
    }
    
    func testAutoWidth() {
        let column = FakeColumn.make(width: "auto")
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.columnWidth, .auto)
        XCTAssertEqual(columnView.contentHuggingPriority(for: .horizontal), ColumnWidth.auto.huggingPriority)
        XCTAssertEqual(columnView.contentCompressionResistancePriority(for: .horizontal), .defaultHigh)
    }
    
    func testStretchWidth() {
        let column = FakeColumn.make(width: "stretch")
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.columnWidth, .stretch)
        XCTAssertEqual(columnView.contentHuggingPriority(for: .horizontal), ColumnWidth.stretch.huggingPriority)
        XCTAssertEqual(columnView.contentCompressionResistancePriority(for: .horizontal), .defaultLow)
    }
    
    func testWeightedWidth() {
        let column = FakeColumn.make(width: "20")
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.columnWidth, .weighted(20))
    }
    
    func testConstantWidth() {
        let column = FakeColumn.make(width: "0", pixelWidth: 200)
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.columnWidth, .fixed(200))
        XCTAssertEqual(columnView.fittingSize.width, 200)
    }
    
    func testMinHeight() {
        let column = FakeColumn.make(minHeight: 200)
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.fittingSize.height, 200)
    }
    
    func testVerticalContentAlignment() {
        // since we removed padding view all together and replaced with lastPadding but use paddingView for vertical content alignment this has changed
        var column = FakeColumn.make(items: [FakeTextBlock.make()], verticalContentAlignment: .center)
        var columnView = renderColumnView(column)
        XCTAssertEqual(columnView.arrangedSubviews.count, 4)
        
        column = .make(items: [FakeTextBlock.make()], verticalContentAlignment: .bottom)
        columnView = renderColumnView(column)
        XCTAssertEqual(columnView.arrangedSubviews.count, 3)
        
        column = .make(items: [FakeTextBlock.make(heightType: .stretch)], verticalContentAlignment: .center)
        columnView = renderColumnView(column)
        XCTAssertTrue(columnView.arrangedSubviews.last?.isHidden ?? false)
        XCTAssertEqual(columnView.arrangedSubviews.count, 2)
    }
    
    func testBleedView() {
        let backgroundImage = FakeBackgroundImage.make(url: "https://picsum.photos/200", fillMode: .cover)
        hostConfig = .make(spacing: ACSSpacingConfig.init(smallSpacing: 4, defaultSpacing: 6, mediumSpacing: 8, largeSpacing: 10, extraLargeSpacing: 14, paddingSpacing: 12))
        
        let column = FakeColumn.make(bleed: true, backgroundImage: backgroundImage, padding: true)
        let columnView = renderColumnView(column)
        
        XCTAssertFalse(columnView.bleedViewTopLayoutConstraint?.isActive ?? true)
        XCTAssertFalse(columnView.bleedViewBottomLayoutConstraint?.isActive ?? true)
        XCTAssertFalse(columnView.bleedViewLeadingLayoutConstraint?.isActive ?? true)
        XCTAssertFalse(columnView.bleedViewTrailingLayoutConstraint?.isActive ?? true)
        
        BaseCardElementRenderer.shared.configBleed(for: columnView, with: hostConfig, element: column)
        
        XCTAssertEqual(columnView.bleedViewTopLayoutConstraint?.constant, -12)
        XCTAssertEqual(columnView.bleedViewBottomLayoutConstraint?.constant, 12)
        XCTAssertEqual(columnView.bleedViewLeadingLayoutConstraint?.constant, -12)
        XCTAssertEqual(columnView.bleedViewTrailingLayoutConstraint?.constant, 12)
        
        XCTAssertEqual(columnView.backgroundImageViewTopConstraint.constant, -12)
        XCTAssertEqual(columnView.backgroundImageViewBottomConstraint.constant, 12)
        XCTAssertEqual(columnView.backgroundImageViewLeadingConstraint.constant, -12)
        XCTAssertEqual(columnView.backgroundImageViewTrailingConstraint.constant, 12)
        
        XCTAssertEqual(columnView.stackViewTopLayoutConstraint?.constant, 0)
        XCTAssertEqual(columnView.stackViewBottomLayoutConstraint?.constant, 0)
        XCTAssertEqual(columnView.stackViewLeadingLayoutConstraint?.constant, 0)
        XCTAssertEqual(columnView.stackViewTrailingLayoutConstraint?.constant, 0)
    }
    
    func testSelectActionTargetIsSet() {
        var columnView: ACRColumnView!
        
        var column = FakeColumn.make(selectAction: FakeSubmitAction.make())
        columnView = renderColumnView(column)
        
        XCTAssertNotNil(columnView.target)
        XCTAssertTrue(columnView.target is ActionSubmitTarget)
        XCTAssertTrue(columnView.canBecomeKeyView)
        XCTAssertTrue(columnView.acceptsFirstResponder)
        
        column = .make(selectAction: FakeOpenURLAction.make())
        columnView = renderColumnView(column)
        
        XCTAssertNotNil(columnView.target)
        XCTAssertTrue(columnView.target is ActionOpenURLTarget)
        XCTAssertTrue(columnView.canBecomeKeyView)
        XCTAssertTrue(columnView.acceptsFirstResponder)
        
        column = .make(selectAction: FakeToggleVisibilityAction.make())
        columnView = renderColumnView(column)
        
        XCTAssertNotNil(columnView.target)
        XCTAssertTrue(columnView.target is ActionToggleVisibilityTarget)
        XCTAssertTrue(columnView.canBecomeKeyView)
        XCTAssertTrue(columnView.acceptsFirstResponder)
        
        // ShowCard Action is not available as a SelectAction
        column = .make(selectAction: FakeShowCardAction.make())
        columnView = renderColumnView(column)
    
        XCTAssertNil(columnView.target)
        XCTAssertFalse(columnView.canBecomeKeyView)
        XCTAssertFalse(columnView.acceptsFirstResponder)
    }
    
    func testRendersItems() {
        let column = FakeColumn.make(items: [FakeTextBlock.make(), FakeInputNumber.make()])
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.arrangedSubviews.count, 4)
    }
    
    func testDateFieldWidth() {
        let column = FakeColumn.make(items: [FakeInputDate.make()])
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.minWidthConstraint.constant, 100)
    }
    
    func testIntrinsicContentSizeWithHiddenInputElements() {
        let inputField = FakeInputText.make(id: "id", isRequired: true, errorMessage: "error message", label: "label message", separator: false, heightType: .auto, isVisible: false)
        let column = FakeColumn.make(isVisible: true, items: [inputField])
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.intrinsicContentSize, .zero)
    }
    
    func testPaddingWhenContainerEmptyWithoutStyle() {
        // No padding added
        let column = FakeColumn.make(isVisible: true, style: .none)
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.stackView.arrangedSubviews.count, 1)
    }
    
    func testColumnWithHeight() {
        let column = FakeColumn.make(isVisible: true, style: .accent, height: .stretch)
        let columnView = renderColumnView(column)
        XCTAssertEqual(columnView.stackView.arrangedSubviews.count, 1)
    }
    
    func testEmptyColumnRendersWithoutError() {
        let column = FakeColumn.make(items: [])
        
        XCTAssertNoThrow(renderColumnView(column))
    }
    
    func testRendererInheritsVerticalContentAlignment() {
        var parentColumn = FakeColumn.make(verticalContentAlignment: .top)
        var parentColumnView = renderColumnView(parentColumn)
        let column = FakeColumn.make(items: [FakeTextBlock.make()], verticalContentAlignment: .nil)
        var columnView = renderColumnView(column, parentView: parentColumnView)
        
        // For HeightType Property we have add stretchable view. so it will increase count for subviews.
        XCTAssertEqual(columnView.stackView.arrangedSubviews.capacity, 2)
        
        parentColumn = FakeColumn.make(verticalContentAlignment: .center)
        parentColumnView = renderColumnView(parentColumn)
        columnView = renderColumnView(column, parentView: parentColumnView)
        
        // SpaceView 2
        XCTAssertEqual(columnView.stackView.arrangedSubviews.capacity, 4)
        
        parentColumn = FakeColumn.make(verticalContentAlignment: .bottom)
        parentColumnView = renderColumnView(parentColumn)
        columnView = renderColumnView(column, parentView: parentColumnView)
        // since we removed padding view all together and replaced with lastPadding but use paddingView for vertical content alignment this has changed
        // SpaceView 1
        XCTAssertEqual(columnView.stackView.arrangedSubviews.capacity, 3)
    }
    
    func testInvisibleViewsWithVerticalContentAlignment() {
        let stretcableView = FakeColumn.make(height: .stretch)
        let column = FakeColumn.make(items: [stretcableView], verticalContentAlignment: .bottom)
        let columnView = renderColumnView(column)
        
        // Normally there are 3 subviews in case of botom, with stretcable view, it is reduced to 2
        XCTAssertEqual(columnView.stackView.arrangedSubviews.capacity, 2)
    }
    
    private func renderColumnView(_ element: ACSColumn, parentView: NSView = NSView()) -> ACRColumnView {
        let view = columnRenderer.render(element: element, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: parentView, inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRContentStackView)
        guard let columnView = view as? ACRColumnView else { fatalError() }
        return columnView
    }
}
