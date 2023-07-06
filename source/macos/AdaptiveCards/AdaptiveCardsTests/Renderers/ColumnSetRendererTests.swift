@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ColumnSetRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var columnSet: FakeColumnSet!
    private var columnSetRenderer: ColumnSetRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        columnSet = .make()
        columnSetRenderer = ColumnSetRenderer()
    }
    
    func testHeightProperty() {
        let columns: [FakeColumn] = [.make(width: "stretch"), .make(width: "stretch")]
        
        let autoColumnSet = FakeColumnSet.make(columns: columns, heightType: .auto)
        let rootAutoView = renderColumnSetInsideContainerView(FakeContainer.make(elemType: .container, minHeight: 200, items: [autoColumnSet]))
        // Since no padding is added and is handled by lastPadding, decrease number of elements
        XCTAssertEqual(rootAutoView.stackView.arrangedSubviews.capacity, 2)
        XCTAssertEqual(rootAutoView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultLow)
        
        let stretchColumnSet = FakeColumnSet.make(columns: columns, heightType: .stretch)
        let rootStretchView = renderColumnSetInsideContainerView(FakeContainer.make(elemType: .container, minHeight: 200, items: [stretchColumnSet]))
        XCTAssertEqual(rootStretchView.stackView.arrangedSubviews.capacity, 2)
        XCTAssertEqual(rootStretchView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    private func renderColumnSetInsideContainerView(_ element: ACSContainer) -> ACRContainerView {
        // Test Container
        let containerRenderer = ContainerRenderer()
        let view = containerRenderer.render(element: element, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRContainerView)
        guard let containerView = view as? ACRContainerView else { fatalError() }
        return containerView
    }
    
    func testAllStretchColumns() {
        let columns: [FakeColumn] = [.make(width: "stretch"), .make(width: "stretch"), .make(width: "stretch")]
        columnSet = .make(columns: columns)
        
        let columnSetView = renderColumnSetView()
        XCTAssertEqual(columnSetView.distribution, .fill)
    }
    
    func testAllAutoColumns() {
        let columns: [FakeColumn] = [.make(width: "auto"), .make(width: "auto"), .make(width: "auto")]
        columnSet = .make(columns: columns)
        
        let columnSetView = renderColumnSetView()
        XCTAssertEqual(columnSetView.distribution, .gravityAreas)
    }
    
    func testMixedWidthColumns() {
        let columns: [FakeColumn] = [.make(width: "auto"), .make(width: "stretch"), .make(width: "2")]
        columnSet = .make(columns: columns)
        
        let columnSetView = renderColumnSetView()
        XCTAssertEqual(columnSetView.distribution, .fill)
    }
    
    func testBleedView() {
        hostConfig = .make(spacing: ACSSpacingConfig.init(smallSpacing: 4, defaultSpacing: 6, mediumSpacing: 8, largeSpacing: 10, extraLargeSpacing: 14, paddingSpacing: 12))
        columnSet = .make(columns: [FakeColumn.make(), FakeColumn.make()], bleed: true, padding: true)
        
        let columnSetView = renderColumnSetView()
        
        XCTAssertFalse(columnSetView.bleedViewTopLayoutConstraint?.isActive ?? true)
        XCTAssertFalse(columnSetView.bleedViewBottomLayoutConstraint?.isActive ?? true)
        XCTAssertFalse(columnSetView.bleedViewLeadingLayoutConstraint?.isActive ?? true)
        XCTAssertFalse(columnSetView.bleedViewTrailingLayoutConstraint?.isActive ?? true)
        
        BaseCardElementRenderer.shared.configBleed(for: columnSetView, with: hostConfig, element: columnSet)
        
        XCTAssertEqual(columnSetView.bleedViewTopLayoutConstraint?.constant, -12)
        XCTAssertEqual(columnSetView.bleedViewBottomLayoutConstraint?.constant, 12)
        XCTAssertEqual(columnSetView.bleedViewLeadingLayoutConstraint?.constant, -12)
        XCTAssertEqual(columnSetView.bleedViewTrailingLayoutConstraint?.constant, 12)
        
        XCTAssertEqual(columnSetView.stackViewTopLayoutConstraint?.constant, 0)
        XCTAssertEqual(columnSetView.stackViewBottomLayoutConstraint?.constant, 0)
        XCTAssertEqual(columnSetView.stackViewLeadingLayoutConstraint?.constant, 0)
        XCTAssertEqual(columnSetView.stackViewTrailingLayoutConstraint?.constant, 0)
    }
    
    func testDefaultOrientation() {
        let columnStackView = renderColumnSetView()
        XCTAssertEqual(columnStackView.orientation, .horizontal)
    }
    
    func testHiddenAndIdPropertiesSet() {
        let columns: [FakeColumn] = [.make(id: "id1", isVisible: false), .make(id: "id2", isVisible: true)]
        columnSet = .make(columns: columns)
        
        let columnSetView = renderColumnSetView()
        let columnViews = columnSetView.arrangedSubviews
        // count -1 for extra padding view between two column
        XCTAssertEqual(columnViews.count - 1, columns.count)
        
        XCTAssertEqual(columnViews[0].identifier?.rawValue, "id1")
        XCTAssertEqual(columnViews[2].identifier?.rawValue, "id2")
        
        XCTAssertTrue(columnViews[0].isHidden)
        XCTAssertFalse(columnViews[2].isHidden)
    }
    
    func testSelectActionTargetIsSet() {
        var columnSetView: ACRContentStackView!
        
        columnSet = .make(selectAction: FakeSubmitAction.make())
        columnSetView = renderColumnSetView()
        
        XCTAssertNotNil(columnSetView.target)
        XCTAssertTrue(columnSetView.target is ActionSubmitTarget)
        XCTAssertTrue(columnSetView.canBecomeKeyView)
        XCTAssertTrue(columnSetView.acceptsFirstResponder)
        
        columnSet = .make(selectAction: FakeOpenURLAction.make())
        columnSetView = renderColumnSetView()
        
        XCTAssertNotNil(columnSetView.target)
        XCTAssertTrue(columnSetView.target is ActionOpenURLTarget)
        XCTAssertTrue(columnSetView.canBecomeKeyView)
        XCTAssertTrue(columnSetView.acceptsFirstResponder)
        
        columnSet = .make(selectAction: FakeToggleVisibilityAction.make())
        columnSetView = renderColumnSetView()
        
        XCTAssertNotNil(columnSetView.target)
        XCTAssertTrue(columnSetView.target is ActionToggleVisibilityTarget)
        XCTAssertTrue(columnSetView.canBecomeKeyView)
        XCTAssertTrue(columnSetView.acceptsFirstResponder)
        
        // ShowCard Action is not available as a SelectAction
        columnSet = .make(selectAction: FakeShowCardAction.make())
        columnSetView = renderColumnSetView()
    
        XCTAssertNil(columnSetView.target)
        XCTAssertFalse(columnSetView.canBecomeKeyView)
        XCTAssertFalse(columnSetView.acceptsFirstResponder)
    }
    
    func testColumnSetNoColumn() {
        let columns: [FakeColumn] = []
        columnSet = .make(columns: columns)
        
        XCTAssertNoThrow(renderColumnSetView())
    }
    
    func testColumnSetWithMultipleColumns() {
        let columns: [FakeColumn] = [.make(width: "auto"), .make(width: "auto"), .make(width: "auto"), .make(width: "auto"), .make(width: "auto"), .make(width: "auto")]
        columnSet = .make(columns: columns)
        let columnSetView = renderColumnSetView()
        
        // Since more than 5 columns width gets divided equally
        XCTAssertEqual(columnSetView.arrangedSubviews[0].fittingSize.width, 72)
        XCTAssertEqual(columnSetView.arrangedSubviews[0].bounds.width, columnSetView.arrangedSubviews[1].bounds.width)
    }
    
    func testColumnSetWithMultipleInputElementInColumns() {
        let columns: [FakeColumn] = [.make(width: "auto", items: [FakeInputText.make()]), .make(width: "auto", items: [FakeInputText.make()]), .make(width: "auto", items: [FakeInputText.make()])]
        columnSet = .make(columns: columns)
        let columnSetView = renderColumnSetView()
        // Since 3 or less column, width is min 100
        XCTAssertEqual(columnSetView.arrangedSubviews[0].fittingSize.width, 100)
        // Since there is padding between the columns are present in position 0, 2, 4
        XCTAssertEqual(columnSetView.arrangedSubviews[0].fittingSize.width, columnSetView.arrangedSubviews[2].fittingSize.width)
    }
    
    func testColumnSetWithFourInputElementInColumns() {
        let columns: [FakeColumn] = [.make(width: "auto", items: [FakeInputText.make()]), .make(width: "auto", items: [FakeInputText.make()]), .make(width: "auto", items: [FakeInputText.make()]), .make(width: "auto", items: [FakeInputText.make()])]
        columnSet = .make(columns: columns)
        let columnSetView = renderColumnSetView()
        // Since more than 3 column, width is min 100
        
        XCTAssertEqual(columnSetView.arrangedSubviews[0].fittingSize.width, 60)
        // Since there is padding between the columns are present in position 0, 2, 4, 6
        XCTAssertEqual(columnSetView.arrangedSubviews[0].fittingSize.width, columnSetView.arrangedSubviews[2].fittingSize.width)
    }
    
    private func renderColumnSetView() -> ACRContentStackView {
        let view = columnSetRenderer.render(element: columnSet, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRContentStackView)
        guard let columnSetView = view as? ACRContentStackView else { fatalError() }
        return columnSetView
    }
    
    public func renderColumnSetViewForActionset(hostConfig: FakeHostConfig, columnSet: FakeColumnSet) -> ACRContentStackView {
        self.hostConfig = hostConfig
        self.columnSet = columnSet
        columnSetRenderer = ColumnSetRenderer()
        return renderColumnSetView()
    }
}
