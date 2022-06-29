import AdaptiveCards_bridge
import AppKit

class ChoiceSetInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ChoiceSetInputRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let choiceSetInput = element as? ACSChoiceSetInput else {
            logError("ChoiceSetInputRenderer -> element is not of type ACSChoiceSetInput")
            return NSView()
        }
        logInfo("ChoiceSetInputRenderer -> init")
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
        logInfo("ChoiceSetInputRenderer -> internal render")
        // Parse input default values for multi-select
        let defaultParsedValues = parseChoiceSetInputDefaultValues(value: choiceSetInput.getValue() ?? "")
        let isMultiSelect = choiceSetInput.getIsMultiSelect()
        let view = ACRChoiceSetView(renderConfig: renderConfig)
        view.isRadioGroup = !isMultiSelect
        view.wrap = choiceSetInput.getWrap()
        view.idString = choiceSetInput.getId()
        view.isRequired = choiceSetInput.getIsRequired()
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
        
        rootView.addInputHandler(view)
        return view
    }
    
    private func parseChoiceSetInputDefaultValues(value: String) -> [String] {
        return value.components(separatedBy: ",")
    }
    
    private func choiceSetCompactRenderInternal (choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, renderConfig: RenderConfig) -> NSView {
        logInfo("ChoiceSetInputRenderer -> internal compact render")
        // compact button renderer
        let choiceSetFieldCompactView = ACRChoiceSetCompactView(element: choiceSetInput, renderConfig: renderConfig)
        choiceSetFieldCompactView.autoenablesItems = false
        var index = 0
        if let placeholder = choiceSetInput.getPlaceholder(), !placeholder.isEmpty {
            choiceSetFieldCompactView.addItem(withTitle: placeholder)
            if let menuItem = choiceSetFieldCompactView.item(at: 0) {
                menuItem.isEnabled = false
            }
            choiceSetFieldCompactView.arrayValues.append(nil)
            index += 1
        }
        choiceSetFieldCompactView.idString = choiceSetInput.getId()
        choiceSetFieldCompactView.isRequired = choiceSetInput.getIsRequired()
        for choice in choiceSetInput.getChoices() {
            let title = choice.getTitle() ?? ""
            choiceSetFieldCompactView.addItem(withTitle: "")
            let item = choiceSetFieldCompactView.item(at: index)
            item?.title = title
            // item?.attributedTitle = getAttributedString(title: title, with: hostConfig, style: style, wrap: choiceSetInput.getWrap())
            choiceSetFieldCompactView.arrayValues.append(choice.getValue())
            if choiceSetInput.getValue() == choice.getValue() {
                choiceSetFieldCompactView.select(item)
                choiceSetFieldCompactView.valueSelected = choice.getValue()
            }
            index += 1
        }
        
        rootView.addInputHandler(choiceSetFieldCompactView)
        choiceSetFieldCompactView.setAccessibilityRoleDescription(renderConfig.localisedStringConfig.choiceSetCompactAccessibilityRoleDescriptor)
        return choiceSetFieldCompactView
    }
}
