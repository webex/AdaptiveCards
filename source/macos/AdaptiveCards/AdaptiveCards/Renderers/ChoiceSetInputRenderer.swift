import AdaptiveCards_bridge
import AppKit

class ChoiceSetInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ChoiceSetInputRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let choiceSetInput = element as? ACSChoiceSetInput else {
            logError("Element is not of type ACSChoiceSetInput")
            return NSView()
        }
        if !choiceSetInput.getIsMultiSelect() {
            // style is compact or expanded
            if choiceSetInput.getChoiceSetStyle() == .compact {
                return choiceSetCompactRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style, rootView: rootView, renderConfig: config)
            } else {
                // radio button renderer
                return choiceSetRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style, rootView: rootView, renderConfig: config)
            }
        }
        // display multi-select check-boxes
        return choiceSetRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style, rootView: rootView, renderConfig: config)
    }
    
    private func choiceSetRenderInternal(choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, renderConfig: RenderConfig) -> NSView {
        // Parse input default values for multi-select
        let choiceSetView = ACRChoiceSetView(config: renderConfig, inputElement: choiceSetInput, hostConfig: hostConfig, style: style, rootView: rootView)
        if choiceSetInput.getHeight() == .stretch {
            if !choiceSetView.getArrangedSubviews.isEmpty {
                choiceSetView.setStretchableHeight()
            }
        }
        rootView.addInputHandler(choiceSetView)
        rootView.accessibilityContext?.registerView(choiceSetView)
        return choiceSetView
    }
    
    private func choiceSetCompactRenderInternal (choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, renderConfig: RenderConfig) -> NSView {
        // compact button renderer
        let view = ACRCompactChoiceSetView(renderConfig: renderConfig, element: choiceSetInput, style: style, with: hostConfig, rootview: rootView)
        rootView.accessibilityContext?.registerView(view)
        return view
    }
}
