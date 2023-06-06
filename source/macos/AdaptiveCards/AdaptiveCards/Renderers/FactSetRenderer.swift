import AdaptiveCards_bridge
import AppKit

class FactSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = FactSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let factSet = element as? ACSFactSet else {
            logError("Element is not of type ACSFactSet")
            return NSView()
        }
        let factsetView = ACRFactSetView(config: config, inputElement: factSet, hostConfig: hostConfig, style: style, rootView: rootView)
        factsetView.translatesAutoresizingMaskIntoConstraints = false
        factsetView.setStretchableHeight()
        if factsetView.hasLink {
            rootView.accessibilityContext?.registerView(factsetView)
        }
        return factsetView
    }
}
