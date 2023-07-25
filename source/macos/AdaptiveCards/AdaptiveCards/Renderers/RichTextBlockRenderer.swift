import AdaptiveCards_bridge
import AppKit

class RichTextBlockRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = RichTextBlockRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let richTextBlock = element as? ACSRichTextBlock else {
            logError("Element is not of type ACSRichTextBlock")
            return NSView()
        }
        
        let textView = ACRTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.layoutManager?.usesFontLeading = false
        textView.backgroundColor = .clear
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: config.hyperlinkColorConfig.foregroundColor,
            NSAttributedString.Key.underlineColor: config.hyperlinkColorConfig.underlineColor,
            NSAttributedString.Key.underlineStyle: config.hyperlinkColorConfig.underlineStyle.rawValue,
            NSAttributedString.Key.cursor: NSCursor.pointingHand
        ]
        textView.linkTextAttributes = linkAttributes
        // init content
        let content = NSMutableAttributedString()
        
        // parsing through the inlines
        for inline in richTextBlock.getInlines() {
            guard let textRun = inline as? ACSTextRun else {
                logError("Not of type ACSTextRun")
                continue
            }
            
            let markdownResult = BridgeTextUtils.processText(fromRichTextBlock: textRun, hostConfig: hostConfig)
            let markdownString = NSMutableAttributedString(string: markdownResult.parsedString)
            markdownString.addAttributes([.font: NSFont.systemFont(ofSize: 12.0)], range: NSRange(location: 0, length: markdownString.length))
            let textRunContent = TextUtils.addFontProperties(attributedString: markdownString, textProperties: BridgeTextUtils.convertTextRun(toRichTextElementProperties: textRun), hostConfig: hostConfig)
            
            // Set paragraph style such as line break mode and alignment
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = ACSHostConfig.getTextBlockAlignment(from: richTextBlock.getHorizontalAlignment())
            textRunContent.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: textRunContent.length))
            
            // Obtain text color to apply to the attributed string
            if let colorHex = hostConfig.getForegroundColor(style, color: textRun.getTextColor(), isSubtle: textRun.getIsSubtle()) {
                let foregroundColor = ColorUtils.color(from: colorHex) ?? NSColor.darkGray
                textRunContent.addAttributes([.foregroundColor: foregroundColor], range: NSRange(location: 0, length: textRunContent.length))
            }
            
            // apply highlight to textrun
            if textRun.getHighlight() {
                if let colorHex = hostConfig.getHighlightColor(style, color: textRun.getTextColor(), isSubtle: textRun.getIsSubtle()) {
                    if let highlightColor = ColorUtils.color(from: colorHex) {
                        textRunContent.addAttributes([.backgroundColor: highlightColor], range: NSRange(location: 0, length: textRunContent.length))
                    }
                }
            }
            
            // Add SelectAction to textRun
            if textRun.getSelectAction() != nil {
                let target = textView.getTargetHandler(for: textRun.getSelectAction(), rootView: rootView)
                if let actionTarget = target {
                    textRunContent.addAttributes([.selectAction: actionTarget], range: NSRange(location: 0, length: textRunContent.length))
                    textRunContent.addAttributes(linkAttributes, range: NSRange(location: 0, length: textRunContent.length))
                    textRunContent.addAttributes([.accessibilityLink: true], range: NSRange(location: 0, length: textRunContent.length))
                    // setup textView to handle selectAction events
                    textView.setupSelectAction(textRun.getSelectAction(), rootView: rootView)
                }
            }
            
            // apply strikethrough to textrun
            if textRun.getStrikethrough() {
                textRunContent.addAttributes([.strikethroughStyle: 1], range: NSRange(location: 0, length: textRunContent.length))
            }
            
            // apply underline to textrun
            if config.supportsSchemeV1_3, textRun.getUnderline() {
                textRunContent.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: textRunContent.length))
            }
            content.append(textRunContent)
        }
        
        textView.textContainer?.lineBreakMode = .byTruncatingTail
        textView.setAttributedString(str: content)
        textView.openLinkCallBack = { [weak rootView] urlAddress in
            rootView?.handleOpenURLAction(urlString: urlAddress, actionView: textView)
        }
        textView.textContainer?.widthTracksTextView = true
        
        // Set compression priority higher value means that we don’t want the view to shrink smaller than the intrinsic content size.
        textView.setContentCompressionResistancePriority(.required, for: .vertical)

        if richTextBlock.getHeight() == .auto {
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
