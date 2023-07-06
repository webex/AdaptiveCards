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
        if container.getSelectAction() != nil {
            rootView.accessibilityContext?.registerView(containerView)
        }
        containerView.bleed = container.getBleed()
        containerView.frame = parentView.bounds
        // add selectAction
        containerView.setupSelectAction(container.getSelectAction(), rootView: rootView)
        containerView.setupSelectActionAccessibility(on: containerView, for: container.getSelectAction())
        if container.getVerticalContentAlignment() == .nil, let parentView = parentView as? ACRContentStackView {
            containerView.setVerticalContentAlignment(parentView.verticalContentAlignment)
        } else {
            containerView.setVerticalContentAlignment(container.getVerticalContentAlignment())
        }
        
        for (index, element) in container.getItems().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: element.getType())
            let view = renderer.render(element: element, with: hostConfig, style: container.getStyle(), rootView: rootView, parentView: containerView, inputs: [], config: config)
            BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: element, parentView: containerView, rootView: rootView, style: style, hostConfig: hostConfig, config: config, isfirstElement: isFirstElement)
            BaseCardElementRenderer.shared.configBleed(for: view, with: hostConfig, element: element)
        }

        containerView.configureLayoutAndVisibility(minHeight: container.getMinHeight())
        
        if container.getHeight() == .stretch {
            containerView.setStretchableHeight()
        }
        containerView.wantsLayer = true
        return containerView
    }
}
