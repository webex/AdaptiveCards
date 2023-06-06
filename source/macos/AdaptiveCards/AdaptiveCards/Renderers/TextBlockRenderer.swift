import AdaptiveCards_bridge
import AppKit

class TextBlockRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = TextBlockRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let textBlock = element as? ACSTextBlock else {
            logError("Element is not of type ACSTextBlock")
            return NSView()
        }
        let textView = ACRTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.openLinkCallBack = { [weak rootView] urlAddress in
            rootView?.handleOpenURLAction(urlString: urlAddress)
        }
        
        let markdownResult = BridgeTextUtils.processText(from: textBlock, hostConfig: hostConfig)
        let markdownString = TextUtils.getMarkdownString(for: rootView, with: markdownResult)
        let attributedString = TextUtils.addFontProperties(attributedString: markdownString, textProperties: BridgeTextUtils.convertTextBlock(toRichTextElementProperties: textBlock), hostConfig: hostConfig)
        
        textView.isEditable = false
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.layoutManager?.usesFontLeading = false
        
        // NSAttributedString text always sticks to bottom with big lineHeight. so we shifted up from baseline offset by half of its mid point. so text will display in vertically center of frame.
        attributedString.addAttributes([.baselineOffset: (textView.font?.pointSize ?? 0) / 3], range: NSRange(location: 0, length: attributedString.length))
        
        attributedString.enumerateAttributes(in: attributedString.fullRange, using: { attributes, range, _ in
            // need to update attributedString paragraphstyle alignment if it is not set in markdownString
            guard let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle else { return }
            // headIndent default value is 0.0 , so if it is not updated we can proceed to change alignment
            if style.headIndent == 0 {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = ACSHostConfig.getTextBlockAlignment(from: textBlock.getHorizontalAlignment())
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }
        })
        
        if let colorHex = hostConfig.getForegroundColor(style, color: textBlock.getTextColor(), isSubtle: textBlock.getIsSubtle()), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        
        textView.textContainer?.lineBreakMode = .byTruncatingTail
        let resolvedMaxLines = textBlock.getMaxLines()?.intValue ?? 0
        textView.textContainer?.maximumNumberOfLines = textBlock.getWrap() ? resolvedMaxLines : 1
        
        textView.setAttributedString(str: attributedString)
        textView.textContainer?.widthTracksTextView = true
        textView.backgroundColor = .clear
        textView.linkTextAttributes = [
            .foregroundColor: config.hyperlinkColorConfig.foregroundColor,
            .underlineColor: config.hyperlinkColorConfig.underlineColor,
            .underlineStyle: config.hyperlinkColorConfig.underlineStyle.rawValue,
            .cursor: NSCursor.pointingHand
        ]
        
        if attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Hide accessibility Element
        }
        
        // Set compression priority higher value means that we don’t want the view to shrink smaller than the intrinsic content size.
        textView.setContentCompressionResistancePriority(.required, for: .vertical)

        if textBlock.getHeight() == .auto {
            // Set Hugging priority Setting a larger value to this priority indicates that we don’t want the view to grow larger than its content.
            textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        } else {
            // Set Hugging priority Setting a lower value to this priority indicates that we want the view to grow larger than its content.
            textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        if textView.canBecomeKeyView {
            rootView.accessibilityContext?.registerView(textView)
        }
        return textView
    }
}

extension NSAttributedString.Key {
    static let selectAction = NSAttributedString.Key("selectAction")
}
