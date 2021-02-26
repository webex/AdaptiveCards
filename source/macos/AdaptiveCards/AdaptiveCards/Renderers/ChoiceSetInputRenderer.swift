import AdaptiveCards_bridge
import AppKit

class ChoiceSetInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ChoiceSetInputRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let choiceSetInput = element as? ACSChoiceSetInput else {
            return NSView()
        }
        if !choiceSetInput.getIsMultiSelect() {
            // style is compact or expanded
            if choiceSetInput.getChoiceSetStyle() == .compact {
                return  choiceSetCompactRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style)
            } else {
                // radio button renderer
                return choiceSetRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style)
            }
        }
        // display multi-select check-boxes
        return choiceSetRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style)
    }
    
    func choiceSetRenderInternal(choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle) -> NSView {
        // Parse input default values for multi-select
        let defaultParsedValues = parseChoiceSetInputDefaultValues(value: choiceSetInput.getValue() ?? "")
        let isMultiSelect = choiceSetInput.getIsMultiSelect()
        let view = ACRChoiceSetView()
        view.isRadioGroup = !isMultiSelect
        view.wrap = choiceSetInput.getWrap()
        for choice in choiceSetInput.getChoices() {
            let title = choice.getTitle() ?? ""
            let attributedString = getAttributedString(title: title, with: hostConfig, style: style)
            let choiceButton = view.setupButton(attributedString: attributedString, value: choice.getValue())
            if isMultiSelect {
                // checkbox
                choiceButton.type = .switch
            } else {
                // radio box
                choiceButton.type = .radio
            }
            choiceButton.backgroundColor = hostConfig.getBackgroundColor(for: style) ?? .clear
            if defaultParsedValues.contains(choice.getValue() ?? "") {
                choiceButton.state = .on
                view.previousButton = choiceButton
            }
            view.addChoiceButton(choiceButton)
        }
        return view
    }
    
    func parseChoiceSetInputDefaultValues(value: String) -> [String] {
        let parsedValues = value.components(separatedBy: ",")
        return parsedValues
    }
}
// MARK: Extension
extension ChoiceSetInputRenderer {
    func choiceSetCompactRenderInternal (choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle) -> NSView {
        // compact button renderer
        let choiceSetFieldCompactView = ACRChoiceSetCompactView()
        choiceSetFieldCompactView.autoenablesItems = false
        var index = 0
        if choiceSetInput.getPlaceholder() != "" {
            choiceSetFieldCompactView.addItem(withTitle: choiceSetInput.getPlaceholder() ?? "")
            if let menuItem = choiceSetFieldCompactView.item(at: 0) {
                menuItem.isEnabled = false
            }
            index += 1
        }
        for choice in choiceSetInput.getChoices() {
            let title = choice.getTitle() ?? ""
            choiceSetFieldCompactView.addItem(withTitle: "")
            let item = choiceSetFieldCompactView.item(at: index)
            item?.title = title
            // item?.attributedTitle = getAttributedString(title: title, with: hostConfig, style: style, wrap: choiceSetInput.getWrap())
            if choiceSetInput.getValue() == choice.getValue() {
                choiceSetFieldCompactView.select(item)
            }
            index += 1
        }
        return choiceSetFieldCompactView
    }
    
    func getAttributedString(title: String, with hostConfig: ACSHostConfig, style: ACSContainerStyle) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: title)
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString
    }
}
