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
        let defaultParsedValues = parseChoiceSetInputDefaultValues(value: choiceSetInput.getValue() ?? "")
        let isMultiSelect = choiceSetInput.getIsMultiSelect()
        let view = ACRChoiceSetView(renderConfig: renderConfig)
        view.isRadioGroup = !isMultiSelect
        view.wrap = choiceSetInput.getWrap()
        view.idString = choiceSetInput.getId()
        view.isRequired = choiceSetInput.getIsRequired()
        view.errorMessage = choiceSetInput.getErrorMessage()
        for choice in choiceSetInput.getChoices() {
            let title = choice.getTitle() ?? ""
            let attributedString = TextUtils.getRenderAttributedString(text: title, with: hostConfig, renderConfig: renderConfig, rootView: rootView, style: style)
            let choiceButton = view.setupButton(attributedString: attributedString, value: choice.getValue(), for: choiceSetInput)
            if defaultParsedValues.contains(choice.getValue() ?? "") {
                choiceButton.state = .on
                choiceButton.buttonValue = choice.getValue()
                view.previousButton = choiceButton
            }
            view.addChoiceButton(choiceButton)
        }
        
        if choiceSetInput.getHeight() == .stretch {
            if !view.getStackViews.isEmpty {
                view.setStretchableHeight()
            }
        }
        
        rootView.addInputHandler(view)
        return view
    }
    
    private func parseChoiceSetInputDefaultValues(value: String) -> [String] {
        return value.components(separatedBy: ",")
    }
    
    private func choiceSetCompactRenderInternal (choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, renderConfig: RenderConfig) -> NSView {
        // compact button renderer
        let view = ACRCompactChoiceSetView(renderConfig: renderConfig, element: choiceSetInput, style: style, with: hostConfig, rootview: rootView)
        return view
    }
}
