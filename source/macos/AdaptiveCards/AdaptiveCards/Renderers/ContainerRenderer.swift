import AdaptiveCards_bridge
import AppKit

class ContainerRenderer: BaseCardElementRendererProtocol {
    static let shared = ContainerRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let container = element as? ACSContainer else {
            logError("Element is not of type ACSContainer")
            return NSView()
        }
        
        let containerView = ACRContainerView(style: container.getStyle(), parentStyle: style, hostConfig: hostConfig, renderConfig: config, superview: rootView, needsPadding: container.getPadding())
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.bleed = container.getBleed()
        containerView.frame = parentView.bounds
        // add selectAction
        containerView.setupSelectAction(container.getSelectAction(), rootView: rootView)
        containerView.setupSelectActionAccessibility(on: containerView, for: container.getSelectAction())
        
        var leadingBlankSpace: SpacingView?
        if container.getVerticalContentAlignment() == .center || container.getVerticalContentAlignment() == .bottom {
            let view = SpacingView()
            containerView.addArrangedSubview(view)
            leadingBlankSpace = view
        }
        
        for (index, element) in container.getItems().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: element.getType())
            let view = renderer.render(element: element, with: hostConfig, style: container.getStyle(), rootView: rootView, parentView: containerView, inputs: [], config: config)
            BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: element, parentView: containerView, rootView: rootView, style: style, hostConfig: hostConfig, config: config, isfirstElement: isFirstElement)
            BaseCardElementRenderer.shared.configBleed(collectionView: view, parentView: containerView, with: hostConfig, element: element, parentElement: container)
        }
        containerView.configureLayout(container.getVerticalContentAlignment(), minHeight: container.getMinHeight() ?? 0, heightType: container.getHeight(), type: .container)
        
        // Dont add the trailing space if the vertical content alignment is top/default
        if container.getVerticalContentAlignment() == .center, let topView = leadingBlankSpace {
            let view = SpacingView()
            containerView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        }
        containerView.wantsLayer = true
        return containerView
    }
}
