import AdaptiveCards_bridge
import AppKit

class FactSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = FactSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let factSet = element as? ACSFactSet else {
            logError("Element is not of type ACSFactSet")
            return NSView()
        }
        let factArray = factSet.getFacts()
        let columnStack = NSStackView()
        columnStack.orientation = .vertical
        columnStack.translatesAutoresizingMaskIntoConstraints = false
        
        for fact in factArray {
            let view = ACRFactSetElement()
            view.setLabel(string: fact.getTitle())
            view.setValue(string: fact.getValue())
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
                view.labelText.textColor = textColor
                view.valueText.textColor = textColor
            }
            view.labelText.preferredMaxLayoutWidth = columnStack.frame.width / 2
            view.valueText.preferredMaxLayoutWidth = columnStack.frame.width / 2
            columnStack.addView(view, in: .bottom)
        }
        return columnStack
    }
}
