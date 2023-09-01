import AppKit
import Carbon.HIToolbox

enum ACRTextViewElementType {
    case choiceInput
    case multilineTextView
    case richTextBlock
    case factset
}

class ACRTextViewHyperLinkData {
    var linkText: String
    var linkAddress: String
    var target: TargetHandler?
    var linkRange: NSRange
    
    init(text: String, address: String, target: TargetHandler?, range: NSRange) {
        self.linkText    = text
        self.linkAddress = address
        self.target      = target
        self.linkRange   = range
    }
}

class ACRTextView: NSTextView, SelectActionHandlingProtocol {
    weak var responderDelegate: ACRTextViewResponderDelegate?
    var placeholderAttrString: NSAttributedString?
    var placeholderLeftPadding: CGFloat?
    var placeholderTopPadding: CGFloat?
    var target: TargetHandler?
    var elementType: ACRTextViewElementType?
    var openLinkCallBack: ((String) -> Void)?
    
    private var clickOnLink = false
    private lazy var linkDataList: [ACRTextViewHyperLinkData] = []
    var hasLinks: Bool {
        return !linkDataList.isEmpty
    }
    private lazy var selectedLinkIndex: Int = -1
    private lazy var keyTabEntry = false
    
    // AccessibleFocusView property
    weak var exitView: AccessibleFocusView?
    
    override public var canBecomeKeyView: Bool {
        return isEditable ? super.canBecomeKeyView : hasLinks
    }
    
    override public var focusRingMaskBounds: NSRect {
        return self.bounds
    }
    
    override public func drawFocusRingMask() {
        if hasLinks || isEditable {
            self.bounds.fill()
            self.needsDisplay = true
        }
    }
    
    func setAttributedString(str: NSAttributedString) {
        self.textStorage?.setAttributedString(str)
        updateHyperLinks()
    }
    
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            return super.intrinsicContentSize
        }
        layoutManager.ensureLayout(for: textContainer)
        let size = layoutManager.usedRect(for: textContainer).size
        let width = size.width + 2
        return NSSize(width: width, height: size.height)
    }
    
    // This point onwards adds placeholder funcunality to TextView
    override func becomeFirstResponder() -> Bool {
        self.needsDisplay = true
        responderDelegate?.textViewDidBecomeFirstResponder()
        return super.becomeFirstResponder()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard string.isEmpty else { return }
        placeholderAttrString?.draw(in: dirtyRect.insetBy(dx: placeholderLeftPadding ?? 5, dy: placeholderTopPadding ?? 0))
    }
    
    override func resignFirstResponder() -> Bool {
        self.needsDisplay = true
        clearSelectedRange()
        responderDelegate?.textViewDidResignFirstResponder()
        selectedLinkIndex = -1
        keyTabEntry = false
        return super.resignFirstResponder()
    }
    
    // This method set boolen True When user click on the hyperlink in the text.
    override func clicked(onLink link: Any, at charIndex: Int) {
        self.openLinkCallBack?((link as? URL)?.absoluteString ?? "")
        if elementType == .choiceInput {
            clickOnLink = true
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if elementType == .choiceInput {
            if !clickOnLink {
                superview?.mouseDown(with: event)
            } else {
                clickOnLink = false
            }
            return
        }
        guard target != nil else { return }
        
        // SelectAction exists
        let location = convert(event.locationInWindow, from: nil)
        var fraction: CGFloat = 0.0
        if let textContainer = self.textContainer, let textStorage = self.textStorage, let layoutManager = self.layoutManager {
            let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: &fraction)
            if characterIndex < textStorage.length, let action = textStorage.attribute(.selectAction, at: characterIndex, effectiveRange: nil) as? TargetHandler {
                action.handleSelectionAction(for: self)
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_Return, kVK_Space:
            if !isEditable {
                let selectedRange = self.selectedRange()
                if let data = linkDataList.first(where: { data in
                    return selectedRange == data.linkRange
                }) {
                    if !data.linkAddress.isEmpty {
                        self.openLinkCallBack?(data.linkAddress)
                    } else if let action = data.target {
                        action.handleSelectionAction(for: self)
                    }
                }
            }
        case kVK_Tab:
            if !isEditable {
                if event.modifierFlags.contains(.shift) {
                    if keyTabEntry, let data = getPreviousTextViewHyperLinkDataClosestToSelectedRange() {
                        self.setSelectedRange(data.linkRange)
                        return
                    }
                } else {
                    if let data = getNextTextViewHyperLinkDataClosestToSelectedRange() {
                        self.setSelectedRange(data.linkRange)
                        keyTabEntry = true
                        return
                    }
                }
            }
        case kVK_Escape:
            self.window?.makeFirstResponder(nil)
        default:
            break
        }
        super.keyDown(with: event)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard target != nil, frame.contains(point) else {
            return super.hitTest(point)
        }
        
        // SelectAction exists
        var location = convert(point, from: self)
        location.y = self.bounds.height - location.y
        var fraction: CGFloat = 0.0
        if let textContainer = self.textContainer, let textStorage = self.textStorage, let layoutManager = self.layoutManager {
            let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: &fraction)
            if characterIndex < textStorage.length, textStorage.attribute(.selectAction, at: characterIndex, effectiveRange: nil) != nil {
                return self
            }
        }
        return super.hitTest(point)
    }
    
    func clearSelectedRange() {
        let selectedString = (string as NSString).substring(with: selectedRange())
        if !selectedString.isEmpty {
            setSelectedRange(NSRange(location: 0, length: 0))
        }
    }
    
    convenience init(asFactSetFieldWith config: HyperlinkColorConfig) {
        self.init()
        setContentCompressionResistancePriority(.required, for: .vertical)
        alignment = .left
        isEditable = false
        backgroundColor = .clear
        linkTextAttributes = [
            .foregroundColor: config.foregroundColor,
            .underlineColor: config.underlineColor,
            .underlineStyle: config.underlineStyle.rawValue,
            .cursor: NSCursor.pointingHand
        ]
        self.elementType = .factset
    }
    
    private func updateHyperLinks() {
        linkDataList = []
        let attrString = self.attributedString()
        let fullTextRange = NSRange(location: 0, length: attrString.length)
        
        attrString.enumerateAttributes(in: fullTextRange) {(keyValue, range: NSRange, _: UnsafeMutablePointer<ObjCBool>) -> Void in
            if let linkStr = keyValue[.link] as? String {
                updateLinkTextAttributes(range: range, attrString: attrString, target: nil, linkAddr: linkStr)
            }
            if let linkUrl = keyValue[.link] as? NSURL, let linkStr = linkUrl.absoluteString {
                updateLinkTextAttributes(range: range, attrString: attrString, target: nil, linkAddr: linkStr)
            }
            if let target = keyValue[.selectAction] as? TargetHandler {
                updateLinkTextAttributes(range: range, attrString: attrString, target: target, linkAddr: "")
            }
        }
    }
    
    private func updateLinkTextAttributes(range: NSRange, attrString: NSAttributedString, target: TargetHandler?, linkAddr: String) {
        if let rangeInString = Range(range, in: attrString.string) {
            let textAtRange = String(self.string[rangeInString])
            if !self.linkDataList.contains(where: { data in
                return data.linkRange == range && data.linkText == textAtRange
            }) {
                self.linkDataList.append(ACRTextViewHyperLinkData(text: textAtRange, address: linkAddr, target: target, range: range))
            }
        }
    }
    
    private func getNextTextViewHyperLinkDataClosestToSelectedRange() -> ACRTextViewHyperLinkData? {
        if linkDataList.isEmpty { return nil }
        setAccessibilityRole(NSAccessibility.Role.link)
        let selectedRange = self.selectedRange()
        if let index = linkDataList.firstIndex(where: { data in
            return data.linkRange == selectedRange }) {
            let nextIndex = index + 1
            if linkDataList.count > nextIndex {
                selectedLinkIndex = nextIndex
                return linkDataList[nextIndex]
            } else {
                return nil
            }
        }
        selectedLinkIndex = 0
        return linkDataList[0]
    }
    
    private func getPreviousTextViewHyperLinkDataClosestToSelectedRange() -> ACRTextViewHyperLinkData? {
        if linkDataList.isEmpty { return nil }
        setAccessibilityRole(NSAccessibility.Role.link)
        let selectedRange = self.selectedRange()
        if let index = linkDataList.firstIndex(where: { data in
            return data.linkRange == selectedRange }) {
            let previousIndex = index - 1
            
            if previousIndex >= 0 {
                selectedLinkIndex = previousIndex
                return linkDataList[previousIndex]
            } else {
                return nil
            }
        }
        selectedLinkIndex = 0
        return linkDataList[linkDataList.count - 1]
    }
}

extension ACRTextView: AccessibleFocusView {
    var validKeyView: NSView? {
        return self
    }
    
    func setupInternalKeyviews() {
        self.nextKeyView = exitView?.validKeyView
    }
}

protocol ACRTextViewResponderDelegate: AnyObject {
    func textViewDidBecomeFirstResponder()
    func textViewDidResignFirstResponder()
}
