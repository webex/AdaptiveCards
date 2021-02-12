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
//        textView.delegate = self
        if let maxLen = inputBlock.getMaxLength() {
            if Int(truncating: maxLen) > 0 {
                textView.maxLen = Int(maxLen)
//                textView.on.ac
//                textView.textDidChang
//                let lengthCheck = CustomTextFieldFormatter()
//                lengthCheck.setMaximumLength(Int32(maxLen))
//                print(lengthCheck.maximumLength())
            }
        }
        if inputBlock.getIsMultiline() {
            // Makes text go to next line
            print("check")
            textView.cell?.isScrollable = false
            textView.cell?.wraps = true
            textView.cell?.usesSingleLineMode = true
//            textView.maximumNumberOfLines = 2
//            textView.maximumNumberOfLines =2
//            textView.cell?.usesSingleLineMode = false
//            textView.setFrameSize(CGSize(width: 100, height: 200))
            } else {
            // Makes text remain in 1 line
            textView.cell?.usesSingleLineMode = true
            textView.maximumNumberOfLines = 1
            // Make text scroll horizontally
            textView.cell?.isScrollable = true
            textView.cell?.truncatesLastVisibleLine = true
        }
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
        return textView
    }
}

class ACRTextInputView: NSTextField, NSTextFieldDelegate {
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
    var maxLen: Int = 0
    override func textDidChange(_ notification: Notification) {
//        print("New string")

        if maxLen > 0 {
            guard let object = notification.object as? NSTextView else {
                print(notification.object.debugDescription)
                return
            }
                print("Hi")
                if (object.string.count) > maxLen {
                    object.string = String(object.string.dropLast())
            }
        }
    }
}

// Try max charecters
// viewDidload(){
//    yourTextFiled.delegate = self
// }
//
// extension NSTextField{
//    func controlTextDidChange(obj: NSNotification){}
// }
// extension YourViewController:NSTextFieldDelegate{
//    func controlTextDidChange(_ obj: Notification)
//    {
//        let object = obj.object as! NSTextField
//        if object.stringValue.count > yourTextLimit{
//        object.stringValue = String(object.stringValue.dropLast())
//    }
// }
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
