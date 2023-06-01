@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ImageSetRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var imageSet: FakeImageSet!
    private var rootView: FakeRootView!
    private var imageSetRenderer: ImageSetRenderer!
    private var fakeImages: [FakeImage]!
    private let sampleURL = "https://adaptivecards.io/content/cats/1.png"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make(imageSizes: ACSImageSizesConfig(smallSize: 30, mediumSize: 60, largeSize: 120))
        rootView = FakeRootView()
        fakeImages = [.make(url: sampleURL), .make(url: sampleURL), .make(url: sampleURL), .make(url: sampleURL)]
        imageSet = FakeImageSet.make(imageSize: .medium, images: fakeImages)
        imageSetRenderer = ImageSetRenderer()
    }
    
    func testHeightProperty() {
        let autoImageSetVIew = FakeImageSet.make(imageSize: .medium, images: fakeImages, height: .auto)
        let stretchImageSetView = FakeImageSet.make(imageSize: .medium, images: fakeImages, height: .stretch)
        
        let containerView = renderContainerView(FakeContainer.make(elemType: .container, minHeight: 500, items: [autoImageSetVIew, stretchImageSetView]))
        // Since no padding is added and is handled by lastPadding, decrease number of elements
        XCTAssertEqual(containerView.stackView.arrangedSubviews.capacity, 4)
        XCTAssertEqual(containerView.stackView.arrangedSubviews.first?.contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultHigh)
        let secondView = containerView.stackView.arrangedSubviews[2]
        XCTAssertEqual(secondView.contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
        
        imageSet = FakeImageSet.make(imageSize: .medium, images: fakeImages, height: .auto)
        XCTAssertEqual(renderImageSetView().contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultHigh)
        
        imageSet = FakeImageSet.make(imageSize: .medium, images: fakeImages, height: .stretch)
        XCTAssertEqual(renderImageSetView().contentHuggingPriority(for: .vertical), kFillerViewLayoutConstraintPriority)
    }
    
    func testToggleVisiblityProperty() throws {
        let target = FakeToggleVisibilityTarget.make(elementId: "toggle1")
        fakeImages = [.make(url: sampleURL), .make(url: sampleURL, id: "toggle1"), .make(url: sampleURL), .make(url: sampleURL, selectAction: FakeToggleVisibilityAction.make(targetElements: [target]))]
        let imageSetView = FakeImageSet.make(imageSize: .small, images: fakeImages, height: .auto)
        let container = FakeContainer.make(elemType: .container, minHeight: 500, items: [imageSetView])
        
        let fakeContext =  ACOVisibilityContext()
        let mainRootView = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: .default, visibilityContext: fakeContext, accessibilityContext: ACSAccessibilityFocusManager())
        let containerView = ContainerRenderer().render(element: container, with: hostConfig, style: .default, rootView: mainRootView, parentView: mainRootView, inputs: [], config: .default)
        let fakeContainerView = try XCTUnwrap(containerView as? ACRContainerView)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: fakeContainerView, element: container, parentView: mainRootView, rootView: mainRootView, style: .none, hostConfig: hostConfig, config: .default, isfirstElement: true)
        
        let collectionView = try XCTUnwrap(fakeContainerView.arrangedSubviews[0] as? ACRCollectionView)
        XCTAssertFalse(collectionView.imageCell(with: "toggle1")?.isHidden ?? true)
        XCTAssertEqual(collectionView.visibleImageViews.count, 4)
        collectionView.imageViews[3].mouseDown(with: NSEvent())
        XCTAssertTrue(collectionView.imageCell(with: "toggle1")?.isHidden ?? false)
        XCTAssertEqual(collectionView.visibleImageViews.count, 3)
    }
    
    private func renderImageSetView() -> ACRCollectionView {
        let view = imageSetRenderer.render(element: imageSet, with: hostConfig, style: .default, rootView: rootView, parentView: rootView, inputs: [], config: RenderConfig.default)
        
        XCTAssertTrue(view is ACRCollectionView)
        guard let contentView = view as? ACRCollectionView else { fatalError() }
        return contentView
    }
    
    private func renderContainerView(_ element: ACSContainer) -> ACRContainerView {
        let view = ContainerRenderer().render(element: element, with: hostConfig, style: .default, rootView: rootView, parentView: rootView, inputs: [], config: .default)
        XCTAssertTrue(view is ACRContainerView)
        guard let containerView = view as? ACRContainerView else { fatalError() }
        return containerView
    }
}
