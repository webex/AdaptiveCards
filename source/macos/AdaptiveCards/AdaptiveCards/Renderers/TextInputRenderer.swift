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
        let attributedPlaceHolder: NSMutableAttributedString
        var attributedInitialValue: NSMutableAttributedString
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isBordered = true
        textView.isEditable = true

        if let maxLen = inputBlock.getMaxLength(), Int(truncating: maxLen) > 0 {
                textView.maxLen = Int(truncating: maxLen)
        }
        if inputBlock.getIsMultiline() {
            let multiline = ACRMultilineView()
            if let placeholderString = inputBlock.getPlaceholder() {
                multiline.setPlaceholder(placeholder: placeholderString)
            }
            if let valueString = inputBlock.getValue(), !valueString.isEmpty {
                multiline.setValue(value: valueString)
            }
            multiline.maxLen = inputBlock.getMaxLength() as? Int ?? 0
            return multiline
            // Makes text go to next line
//            textView.cell?.isScrollable = false
//            textView.cell?.wraps = true
//            textView.cell?.usesSingleLineMode = false
            } else {
            // Makes text remain in 1 line
            textView.cell?.usesSingleLineMode = true
            textView.maximumNumberOfLines = 1
            // Make text scroll horizontally
            textView.cell?.isScrollable = true
            textView.cell?.truncatesLastVisibleLine = true
            textView.cell?.lineBreakMode = .byTruncatingTail
        }
        // Create placeholder and initial value string if they exist
        if let placeholderString = inputBlock.getPlaceholder() {
            attributedPlaceHolder = NSMutableAttributedString(string: placeholderString)
            if let colorHex = hostConfig.getForegroundColor(style, color: ACSForegroundColor.default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
                attributedPlaceHolder.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedPlaceHolder.length))
            }
            textView.placeholderAttributedString = attributedPlaceHolder
        }
        if let valueString = inputBlock.getValue() {
            attributedInitialValue = NSMutableAttributedString(string: valueString)
            if let maxLen = inputBlock.getMaxLength(), Int(truncating: maxLen) > 0, attributedInitialValue.string.count > Int(truncating: maxLen) {
                attributedInitialValue = NSMutableAttributedString(string: String(attributedInitialValue.string.dropLast(attributedInitialValue.string.count - Int(truncating: maxLen))))
                }
            textView.attributedStringValue = attributedInitialValue
            }
        return textView
    }
}
class ACRTextInputView: NSTextField, NSTextFieldDelegate {
    var maxLen: Int = 0
    override func textDidChange(_ notification: Notification) {
        guard maxLen > 0  else { return } // maxLen returns 0 if propery not set
        guard let textView = notification.object as? NSTextView, textView.string.count > maxLen else { return }
        textView.string = String(textView.string.dropLast())
        if textView.string.count > maxLen {
            textView.string = String(textView.string.dropLast(textView.string.count - maxLen))
        }
    }
}
