//
//  TextInputRenderer.swift
//  AdaptiveCards
//
//  Created by mukuagar on 11/02/21.
//

import AdaptiveCards_bridge
import AppKit

class TextInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = TextInputRenderer()
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let inputBlock = element as? ACSTextInput else {
            logError("Element is not of type ACSTextInput")
            return NSView()
        }
        let textView = ACRTextInputView()
        var attributedPlaceHolder: NSMutableAttributedString
        var attributedInitialValue: NSMutableAttributedString
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isBordered = true
        textView.isEditable = true
        if inputBlock.getIsMultiline() {
            // Makes text go to next line
            print("check")
            textView.cell?.isScrollable = false
            textView.cell?.wraps = true
//            textView.maximumNumberOfLines = 2
//            textView.maximumNumberOfLines =2
//            textView.cell?.usesSingleLineMode = false
//            textView.setFrameSize(CGSize(width: 100, height: 200))
            } else {
            // Makes text scroll horizontally
                textView.cell?.usesSingleLineMode = true
            textView.maximumNumberOfLines = 1
            textView.cell?.isScrollable = true
        }
        
//        textView.backgroundColor = NSColor.clear
        var doesPlaceholderExist = false
        var doesValueExist = false
        // Check if placeholder and initial value exist
        if inputBlock.getPlaceholder() != nil {
            doesPlaceholderExist = true
            }
        if inputBlock.getValue() != nil {
            doesValueExist = true
            }
        // Create placeholder and initial value string if they exist
        if doesPlaceholderExist {
            attributedPlaceHolder = NSMutableAttributedString(string: inputBlock.getPlaceholder() ?? "")
            if let colorHex = hostConfig.getForegroundColor(style, color: ACSForegroundColor.default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
                attributedPlaceHolder.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedPlaceHolder.length))
            }
            textView.placeholderAttributedString = attributedPlaceHolder
        }
        if doesValueExist {
            attributedInitialValue = NSMutableAttributedString(string: inputBlock.getValue() ?? "")
            
            textView.attributedStringValue = attributedInitialValue
            }
//
//        let markdownResult = BridgeTextUtils.processText(from: inputBlock, hostConfig: hostConfig)
//        let attributedString: NSMutableAttributedString
//        if markdownResult.isHTML, let htmlData = markdownResult.htmlData {
//            do {
//                attributedString = try NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//                // Delete trailing newline character
//                attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
//                textView.isSelectable = true
//            } catch {
//                attributedString = NSMutableAttributedString(string: markdownResult.parsedString)
//            }
//        } else {
//            attributedString = NSMutableAttributedString(string: markdownResult.parsedString)
//            // Delete <p> and </p>
//            attributedString.deleteCharacters(in: NSRange(location: 0, length: 3))
//            attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 4, length: 4))
//        }
//
//        textView.isEditable = false
//        textView.textContainer?.lineFragmentPadding = 0
//        textView.textContainerInset = .zero
//        textView.layoutManager?.usesFontLeading = false
//        textView.setContentHuggingPriority(.required, for: .vertical)
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = ACSHostConfig.getTextBlockAlignment(from: textBlock.getHorizontalAlignment())
//
//        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
//
//        if let colorHex = hostConfig.getForegroundColor(style, color: textBlock.getTextColor(), isSubtle: textBlock.getIsSubtle()), let textColor = ColorUtils.color(from: colorHex) {
//            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
//        }
//
//        textView.textContainer?.lineBreakMode = .byTruncatingTail
//        textView.textContainer?.maximumNumberOfLines = textBlock.getMaxLines()?.intValue ?? 0
//        if textView.textContainer?.maximumNumberOfLines == 0 && !textBlock.getWrap() {
//            // TODO: To revisit
//            textView.textContainer?.maximumNumberOfLines = 0
//        }
//
//        textView.textStorage?.setAttributedString(attributedString)
//        textView.font = FontUtils.getFont(for: hostConfig, with: BridgeTextUtils.convertTextBlock(toRichTextElementProperties: textBlock))
//        textView.textContainer?.widthTracksTextView = true
//        textView.backgroundColor = .clear
//
//        if attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            // Hide accessibility Element
//        }
//
//        return textView
        return textView
    }
}

class ACRTextInputView: NSTextField {
//    override var intrinsicContentSize: NSSize {
//        guard let layoutManager = layoutManager, let textContainer = textContainer else {
//            return super.intrinsicContentSize
//        }
//        layoutManager.ensureLayout(for: textContainer)
//        return layoutManager.usedRect(for: textContainer).size
//    }
//
//    override func viewDidMoveToSuperview() {
//        super.viewDidMoveToSuperview()
//        // Should look for better solution
//        guard let superview = superview else { return }
//        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
//    }
}
class AutoGrowingTextField: NSTextField {
    private var placeholderWidth: CGFloat? = 0

    /// Field editor inset; experimental value
    private let rightMargin: CGFloat = 5

    private var lastSize: NSSize?
    private var isEditing = false

    override func awakeFromNib() {
        super.awakeFromNib()

        if let placeholderString = self.placeholderString {
            self.placeholderWidth = sizeForProgrammaticText(placeholderString).width
        }
    }

    override var placeholderString: String? {
        didSet {
            guard let placeholderString = self.placeholderString else { return }
            self.placeholderWidth = sizeForProgrammaticText(placeholderString).width
        }
    }

    override var stringValue: String {
        didSet {
            guard !isEditing else { return }
            self.lastSize = sizeForProgrammaticText(stringValue)
        }
    }

    private func sizeForProgrammaticText(_ string: String) -> NSSize {
        let font = self.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        let stringWidth = NSAttributedString(
            string: string,
            attributes: [ .font: font ])
            .size().width

        // Don't use `self` to avoid cycles
        var size = super.intrinsicContentSize
        size.width = stringWidth
        return size
    }

    override func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        isEditing = true
    }

    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        isEditing = false
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: NSSize {
        var minSize: NSSize {
            var size = super.intrinsicContentSize
            size.width = self.placeholderWidth ?? 0
            return size
        }

        // Use cached value when not editing
        guard isEditing,
            let fieldEditor = self.window?.fieldEditor(false, for: self) as? NSTextView
            else { return self.lastSize ?? minSize }

        // Make room for the placeholder when the text field is empty
        guard !fieldEditor.string.isEmpty else {
            self.lastSize = minSize
            return minSize
        }

        // Use the field editor's computed width when possible
        guard let container = fieldEditor.textContainer,
            let newWidth = container.layoutManager?.usedRect(for: container).width
            else { return self.lastSize ?? minSize }

        var newSize = super.intrinsicContentSize
        newSize.width = newWidth + rightMargin

        self.lastSize = newSize

        return newSize
    }
}

// MARK: Check this later
//            if let colorHex = hostConfig.getForegroundColor(ACSContainerStyle.good, color: ACSForegroundColor.default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
//                attributedInitialValue.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedInitialValue.length))
//            }
