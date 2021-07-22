import AdaptiveCards_bridge
import AppKit

class ContainerRenderer: BaseCardElementRendererProtocol {
    static let shared = ContainerRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let container = element as? ACSContainer else {
            logError("Element is not of type ACSContainer")
            return NSView()
        }
        
        let containerView = ACRColumnView(style: container.getStyle(), parentStyle: style, hostConfig: hostConfig, superview: rootView, needsPadding: container.getPadding())
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.bleed = container.getBleed()
        
        // add selectAction
        containerView.setupSelectAction(container.getSelectAction(), rootView: rootView)
        
        var leadingBlankSpace: SpacingView?
        if container.getVerticalContentAlignment() == .center || container.getVerticalContentAlignment() == .bottom {
            let view = SpacingView()
            containerView.addArrangedSubview(view)
            leadingBlankSpace = view
        }
        
        for (index, item) in container.getItems().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: item.getType())
            let view = renderer.render(element: item, with: hostConfig, style: container.getStyle(), rootView: rootView, parentView: containerView, inputs: [], config: config)
            let viewWithInheritedProperties = BaseCardElementRenderer().updateView(view: view, element: item, rootView: rootView, style: container.getStyle(), hostConfig: hostConfig, config: config, isfirstElement: isFirstElement)
            containerView.addArrangedSubview(viewWithInheritedProperties)
            BaseCardElementRenderer.shared.configBleed(collectionView: view, parentView: containerView, with: hostConfig, element: item, parentElement: container)
        }
        
        // Dont add the trailing space if the vertical content alignment is top/default
        if container.getVerticalContentAlignment() == .center, let topView = leadingBlankSpace {
            let view = SpacingView()
            containerView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        }
        containerView.wantsLayer = true
        
        containerView.setVerticalHuggingPriority(1000)
        return containerView
    }
}
