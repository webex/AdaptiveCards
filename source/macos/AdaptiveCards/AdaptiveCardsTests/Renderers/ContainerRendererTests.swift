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
    
    func testHeightProperty() {
        let autoContainer = FakeContainer.make(elemType: .container, heightType: .auto)
        let rootAutoView = renderContainerView(FakeContainer.make(elemType: .container, minHeight: 200, items: [autoContainer]))
        XCTAssertEqual(rootAutoView.stackView.arrangedSubviews.capacity, 2)
        XCTAssertEqual(rootAutoView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultLow)
        
        let stretchContainer = FakeContainer.make(elemType: .container, heightType: .stretch)
        let rootStretchView = renderContainerView(FakeContainer.make(elemType: .container, minHeight: 200, items: [stretchContainer]))
        XCTAssertEqual(rootStretchView.stackView.arrangedSubviews.capacity, 1)
        XCTAssertEqual(rootStretchView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testRendererSetsVerticalContentAlignment() {
        container = .make(verticalContentAlignment: .top)
        var containerView = renderContainerView(container)
        // For HeightType Property we have add stretchable view. so it will increase count for subviews.
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 1)
        
        container = .make(verticalContentAlignment: .bottom)
        containerView = renderContainerView(container)
        // SpaceView 1
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 2)
        
        container = .make(verticalContentAlignment: .center)
        containerView = renderContainerView(container)
        // SpaceView 2
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 3)
    }
    
    func testSelectActionTargetIsSet() {
        var containerView: ACRContentStackView!
        
        container = .make(selectAction: FakeSubmitAction.make())
        containerView = renderContainerView(container)
        
        XCTAssertNotNil(containerView.target)
        XCTAssertTrue(containerView.target is ActionSubmitTarget)
        
        container = .make(selectAction: FakeOpenURLAction.make())
        containerView = renderContainerView(container)
        
        XCTAssertNotNil(containerView.target)
        XCTAssertTrue(containerView.target is ActionOpenURLTarget)
        
        container = .make(selectAction: FakeToggleVisibilityAction.make())
        containerView = renderContainerView(container)
        
        XCTAssertNotNil(containerView.target)
        XCTAssertTrue(containerView.target is ActionToggleVisibilityTarget)
        
        // ShowCard Action is not available as a SelectAction
        container = .make(selectAction: FakeShowCardAction.make())
        containerView = renderContainerView(container)
    
        XCTAssertNil(containerView.target)
    }
    
    func testRendersItems() {
        /// TO DO: Test Failed due to Height Property which is not yet add in InputToggleView
        /// we will add test case, once done with input toggle
        
        /*container = .make(items: [FakeInputToggle.make()])
        let containerView = renderContainerView(container)
        XCTAssertEqual(containerView.arrangedSubviews.count, 1)*/
    }
    
    private func renderContainerView(_ element: ACSContainer) -> ACRContainerView {
        let view = containerRenderer.render(element: element, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRContainerView)
        guard let containerView = view as? ACRContainerView else { fatalError() }
        return containerView
    }
}
