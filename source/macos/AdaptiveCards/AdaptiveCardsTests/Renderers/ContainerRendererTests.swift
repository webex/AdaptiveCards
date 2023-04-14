@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ContainerRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var container: FakeContainer!
    private var containerRenderer: ContainerRenderer!
   
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        container = .make()
        containerRenderer = ContainerRenderer()
    }
    
    func testRendererSetsStyle() {
        container = .make(style: .none)
        let containerView = renderContainerView(container)
        XCTAssertEqual(containerView.layer?.backgroundColor, nil)
    }
    
    func testStretchableEmptyContainer() {
        let fakeStretchContainer = FakeContainer.make(elemType: .container, heightType: .stretch)
        let stretchContainer = renderContainerView(fakeStretchContainer)
        XCTAssertEqual(stretchContainer.arrangedSubviews.capacity, 1)
    }
    
    func testHeightProperty() {
        let autoContainer = FakeContainer.make(elemType: .container, heightType: .auto)
        let rootAutoView = renderContainerView(FakeContainer.make(elemType: .container, minHeight: 200, items: [autoContainer]))
        // Since no padding is added and is handled by lastPadding, decrease number of elements
        XCTAssertEqual(rootAutoView.stackView.arrangedSubviews.capacity, 2)
        XCTAssertEqual(rootAutoView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultLow)
        
        let stretchContainer = FakeContainer.make(elemType: .container, heightType: .stretch)
        let rootStretchView = renderContainerView(FakeContainer.make(elemType: .container, minHeight: 200, items: [stretchContainer]))
        XCTAssertEqual(rootStretchView.stackView.arrangedSubviews.capacity, 2)
        XCTAssertEqual(rootStretchView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testRendererSetsVerticalContentAlignment() {
        container = .make(verticalContentAlignment: .top, items: [FakeTextBlock.make()])
        // Removing this since we don't need subviews to have padding to have explicit width
        var containerView = renderContainerView(container)
        // For HeightType Property we have add stretchable view. so it will increase count for subviews.
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 2)
        
        container = .make(verticalContentAlignment: .bottom, items: [FakeTextBlock.make()])
        containerView = renderContainerView(container)
        // since we removed padding view all together and replaced with lastPadding but use paddingView for vertical content alignment this has changed
        // SpaceView 1
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 3)
        
        container = .make(verticalContentAlignment: .center, items: [FakeTextBlock.make()])
        containerView = renderContainerView(container)
        // SpaceView 2
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 4)
        
        container = .make(verticalContentAlignment: .center, minHeight: 300, items: [FakeTextBlock.make(heightType: .stretch)])
        containerView = renderContainerView(container)
        XCTAssertTrue(containerView.arrangedSubviews.last?.isHidden ?? false)
        XCTAssertEqual(containerView.arrangedSubviews.count, 2)
    }
    
    func testSelectActionTargetIsSet() {
        var containerView: ACRContentStackView!
        
        container = .make(selectAction: FakeSubmitAction.make())
        containerView = renderContainerView(container)
        
        XCTAssertNotNil(containerView.target)
        XCTAssertTrue(containerView.target is ActionSubmitTarget)
        XCTAssertTrue(containerView.canBecomeKeyView)
        XCTAssertTrue(containerView.acceptsFirstResponder)
        
        container = .make(selectAction: FakeOpenURLAction.make())
        containerView = renderContainerView(container)
        
        XCTAssertNotNil(containerView.target)
        XCTAssertTrue(containerView.target is ActionOpenURLTarget)
        XCTAssertTrue(containerView.canBecomeKeyView)
        XCTAssertTrue(containerView.acceptsFirstResponder)
        
        container = .make(selectAction: FakeToggleVisibilityAction.make())
        containerView = renderContainerView(container)
        
        XCTAssertNotNil(containerView.target)
        XCTAssertTrue(containerView.target is ActionToggleVisibilityTarget)
        XCTAssertTrue(containerView.canBecomeKeyView)
        XCTAssertTrue(containerView.acceptsFirstResponder)
        
        // ShowCard Action is not available as a SelectAction
        container = .make(selectAction: FakeShowCardAction.make())
        containerView = renderContainerView(container)
    
        XCTAssertNil(containerView.target)
        XCTAssertFalse(containerView.canBecomeKeyView)
        XCTAssertFalse(containerView.acceptsFirstResponder)
    }
    
    func testIntrinsicContentSizeWithHiddenInputElements() {
        let inputField = FakeInputText.make(id: "id", isRequired: true, errorMessage: "error message", label: "label message", separator: false, heightType: .auto, isVisible: false)
        let containerView = renderContainerView(FakeContainer.make(elemType: .container, items: [inputField]))
        XCTAssertEqual(containerView.intrinsicContentSize, .zero)
    }
    
    func testPaddingWhenContainerEmptyWithoutStyle() {
        let containerView = renderContainerView(FakeContainer.make(style: .none, elemType: .container, visible: true))
        XCTAssertEqual(containerView.stackView.arrangedSubviews.count, 0)
    }
    
    func testRendersItems() {
        container = .make(items: [FakeInputToggle.make()])
        let containerView = renderContainerView(container)
        XCTAssertEqual(containerView.arrangedSubviews.count, 2)
    }
    
    private func renderContainerView(_ element: ACSContainer) -> ACRContainerView {
        let view = containerRenderer.render(element: element, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRContainerView)
        guard let containerView = view as? ACRContainerView else { fatalError() }
        return containerView
    }
}
