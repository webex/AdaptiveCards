import AdaptiveCards_bridge
import AppKit

class TextInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = TextInputRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let inputBlock = element as? ACSTextInput else {
            logError("Element is not of type ACSTextInput")
            return NSView()
        }
        if inputBlock.getIsMultiline() {
            let inputTextView = ACRMultilineInputTextView(renderConfig: config, element: inputBlock, with: hostConfig, rootview: rootView)
            let attributedString: NSMutableAttributedString
            attributedString = NSMutableAttributedString(string: inputTextView.inlineButtonTitle.isEmpty ? "Action" : inputTextView.inlineButtonTitle)
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
                attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
            }
            inputTextView.inlineButtonAttributedTitle = attributedString
            return inputTextView
        } else {
            let inputTextView = ACRSingleLineInputTextView(renderConfig: config, element: inputBlock, style: style, with: hostConfig, rootview: rootView)
            return inputTextView
        }
    }
}
