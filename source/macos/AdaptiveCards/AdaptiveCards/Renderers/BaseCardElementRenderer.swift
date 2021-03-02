import AdaptiveCards_bridge
import AppKit

class BaseCardElementRenderer {
    func updateView(view: NSView, element: ACSBaseCardElement, style: ACSContainerStyle, hostConfig: ACSHostConfig, isfirstElement: Bool) -> NSView {
        let updatedView = ACRContentStackView()
//        let updatedView = ACRView(style: style, hostConfig: hostConfig)

        if element.getSeparator(), !isfirstElement {
            let seperatorConfig = hostConfig.getSeparator()
            let lineThickness = seperatorConfig?.lineThickness
            let lineColor = seperatorConfig?.lineColor
            updatedView.addSeperator(thickness: lineThickness ?? 1, color: lineColor ?? "#EEEEEE")
        }
        updatedView.addArrangedSubview(view)
        updatedView.isHidden = !element.getIsVisible()
        
        return updatedView
//        return view
    }
}
