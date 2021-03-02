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
        print(element.getSpacing().rawValue)
        if !isfirstElement {
            let spacingConfig = hostConfig.getSpacing()
            let spaceAdded: NSNumber
            switch element.getSpacing() {
            case .default:
                spaceAdded = spacingConfig?.defaultSpacing ?? 0
            case .none: // None
                spaceAdded = 0
            case .small: // Small
                spaceAdded = spacingConfig?.smallSpacing ?? 3
            case .medium: // Medium
                spaceAdded = spacingConfig?.mediumSpacing ?? 20
            case .large: // Large
                spaceAdded = spacingConfig?.largeSpacing ?? 30
            case .extraLarge: // Extralarge
                spaceAdded = spacingConfig?.extraLargeSpacing ?? 40
            case .padding: // Padding
                spaceAdded = spacingConfig?.paddingSpacing ?? 20
            }
            updatedView.addSpacing(spacing: CGFloat(truncating: spaceAdded))
        }
        updatedView.addArrangedSubview(view)
        updatedView.isHidden = !element.getIsVisible()
        
        return updatedView
//        return view
    }
}
