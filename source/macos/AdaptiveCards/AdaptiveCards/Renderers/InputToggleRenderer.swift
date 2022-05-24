import AdaptiveCards_bridge
import AppKit

class InputToggleRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = InputToggleRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let inputToggle = element as? ACSToggleInput else {
            logError("Element is not of type ACSToggleInput")
            return NSView()
        }
        // NSMutableAttributedString for the checkbox title
        let attributedString: NSMutableAttributedString
        // NSButton for checkbox
        let title = inputToggle.getTitle() ?? ""
        let inputToggleView = ACRChoiceButton(renderConfig: config, buttonType: .switch, element: inputToggle)
        // adding attributes to the string
        attributedString = getAttributedString(title: title, with: hostConfig, renderConfig: config, rootView: rootView, style: style)
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        // check for valueOn or valueOff attributes
        var defaultInputToggleStateValue: NSControl.StateValue = .on
        if inputToggle.getValue() != inputToggle.getValueOn() {
            defaultInputToggleStateValue = .off
        }
        inputToggleView.state = defaultInputToggleStateValue
        inputToggleView.labelAttributedString = attributedString
        rootView.addInputHandler(inputToggleView)
        return inputToggleView
    }
    
    private func getAttributedString(title: String, with hostConfig: ACSHostConfig, renderConfig: RenderConfig, rootView: ACRView, style: ACSContainerStyle) -> NSMutableAttributedString {
        var attributedString: NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: title)
        
        let markdownResult = BridgeTextUtils.process(onRawTextString: title, hostConfig: hostConfig)
        attributedString = TextUtils.getMarkdownString(for: rootView, with: markdownResult)
        
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor, .cursor: NSCursor.arrow], range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString
    }
}
