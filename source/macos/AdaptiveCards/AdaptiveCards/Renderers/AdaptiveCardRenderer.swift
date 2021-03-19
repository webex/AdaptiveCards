import AdaptiveCards_bridge
import AppKit

class AdaptiveCardRenderer {
    static let shared = AdaptiveCardRenderer()
    weak var actionDelegate: AdaptiveCardActionDelegate?
    weak var resolverDelegate: AdaptiveCardResourceResolver?
    
    func renderAdaptiveCard(_ card: ACSAdaptiveCard, with hostConfig: ACSHostConfig, width: CGFloat) -> NSView {
        var style: ACSContainerStyle = .default
        if let colorConfig = hostConfig.getAdaptiveCard() {
            style = (colorConfig.allowCustomStyle && card.getStyle() != .none) ? card.getStyle() : .default
        }
        
        let rootView = ACRView(style: style, hostConfig: hostConfig)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.widthAnchor.constraint(equalToConstant: width).isActive = true
        rootView.delegate = self
        rootView.resolverDelegate = self
           
        for (index, element) in card.getBody().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: element.getType())
            let view = renderer.render(element: element, with: hostConfig, style: style, rootView: rootView, parentView: rootView, inputs: [])
            let viewWithInheritedProperties = BaseCardElementRenderer().updateView(view: view, element: element, style: style, hostConfig: hostConfig, isfirstElement: isFirstElement)
            rootView.addArrangedSubview(viewWithInheritedProperties)
        }
        
        for action in card.getActions() {
            let renderer = RendererManager.shared.actionRenderer(for: action.getType())
            let view = renderer.render(action: action, with: hostConfig, style: style, rootView: rootView, parentView: rootView, inputs: [])
            rootView.addArrangedSubview(view)
        }
        
        rootView.appearance = NSAppearance(named: .aqua)
        rootView.layoutSubtreeIfNeeded()
        return rootView
    }
}

extension AdaptiveCardRenderer: ACRViewDelegate {
    func acrView(_ view: ACRView, didSelectOpenURL url: String, button: NSButton) {
        actionDelegate?.adaptiveCard(view, didSelectOpenURL: url, button: button)
    }
}

extension AdaptiveCardRenderer: ACRViewResourceResolverDelegate {
    func resolve(_ adaptiveCard: ImageHandlerView, requestImageFor url: String) {
        resolverDelegate?.adaptiveCard(adaptiveCard, requestImageFor: url)
    }
    func resolve(_ adaptiveCard: ImageHandlerView, dimensionsForImageWith url: String) -> NSSize? {
        resolverDelegate?.adaptiveCard(adaptiveCard, dimensionsForImageWith: url)
    }
}
