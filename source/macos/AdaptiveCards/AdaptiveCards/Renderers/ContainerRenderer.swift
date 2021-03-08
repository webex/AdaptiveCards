import AdaptiveCards_bridge
import AppKit

class ContainerRenderer: BaseCardElementRendererProtocol {
    static let shared = ContainerRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let container = element as? ACSContainer else {
            logError("Element is not of type ACSContainer")
            return NSView()
        }
        
        let containerView = ACRColumnView(style: container.getStyle(), parentStyle: style, hostConfig: hostConfig, superview: rootView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // add bleed
        
        // add background Image
        renderBackgroundImage(backgroundImage: container.getBackgroundImage(), view: containerView, rootview: rootView)
        
        var leadingBlankSpace: NSView? = nil, trailingBlankSpace: NSView? = nil
        
        if container.getVerticalContentAlignment() == .center || container.getVerticalContentAlignment() == .bottom {
            leadingBlankSpace = containerView.addPadding()
        }
        
        for (index, item) in container.getItems().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: item.getType())
            let view = renderer.render(element: item, with: hostConfig, style: container.getStyle(), rootView: rootView, parentView: containerView, inputs: [])
            let viewWithInheritedProperties = BaseCardElementRenderer().updateView(view: view, element: element, style: container.getStyle(), hostConfig: hostConfig, isfirstElement: isFirstElement)
            containerView.addArrangedSubview(viewWithInheritedProperties)
        }
        
        let verticalAlignment = container.getVerticalContentAlignment()
        // Dont add the trailing space if the vertical content alignment is top/default
        if verticalAlignment == .center {
            trailingBlankSpace = containerView.addPadding()
        }
        containerView.wantsLayer = true
        
        if let minHeight = container.getMinHeight(), minHeight.isGreaterThan(0) {
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(truncating: minHeight)).isActive = true
        }
        if leadingBlankSpace != nil && trailingBlankSpace != nil {
            NSLayoutConstraint(item: leadingBlankSpace as Any, attribute: .height, relatedBy: .equal, toItem: trailingBlankSpace, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        }
        return containerView
    }
    private func renderBackgroundImage(backgroundImage: ACSBackgroundImage?, view: NSView, rootview: NSView) {
        // add image
        if backgroundImage == nil, let url = backgroundImage?.getUrl(), url.isEmpty {
            return
        }
    }
}
