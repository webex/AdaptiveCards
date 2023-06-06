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
        let inputToggleView = ACRInputToggleView(renderConfig: config, element: inputToggle)
        // adding attributes to the string
        attributedString = TextUtils.getRenderAttributedString(text: title, with: hostConfig, renderConfig: config, rootView: rootView, style: style)
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
        inputToggleView.choiceButton.buttonLabelField.openLinkCallBack = { [weak rootView] urlAddress in
            rootView?.handleOpenURLAction(urlString: urlAddress)
        }
        rootView.addInputHandler(inputToggleView)
        return inputToggleView
    }
}
