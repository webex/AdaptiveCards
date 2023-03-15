import AppKit

import Carbon.HIToolbox

class ACRTextViewHyperLinkData {
    var linkText: String
    var linkAddress: String
    var linkRange: NSRange
    var linkRect: NSRect
    
    init(text: String, address: String, range: NSRange, rect: NSRect = .zero) {
        self.linkText    = text
        self.linkAddress = address
        self.linkRange   = range
        self.linkRect    = rect
    }
}

class ACRTextView: NSTextView, SelectActionHandlingProtocol {
    weak var responderDelegate: ACRTextViewResponderDelegate?
    var placeholderAttrString: NSAttributedString?
    var placeholderLeftPadding: CGFloat?
    var placeholderTopPadding: CGFloat?
    var target: TargetHandler?
    var openLinkCallBack: ((String) -> Void)?
    
    var selectLinkTextWhenBecomeFirstResponder = true
    private var linkDataList: [ACRTextViewHyperLinkData] = []
    var hasLinks: Bool {
        return !linkDataList.isEmpty
    }
    private var selectedLinkIndex: Int = -1
    private var  keyTabEntry = false
    
    override public var acceptsFirstResponder: Bool {
        return hasLinks
    }
    
    override public var canBecomeKeyView: Bool {
        return hasLinks
    }
    
    override public var focusRingMaskBounds: NSRect {
        return self.bounds
    }
    
    override public func drawFocusRingMask() {
        if hasLinks {
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
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
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
        var bHandled = false
        let keyCode = Int(event.keyCode)
        
        switch keyCode {
        case kVK_Return, kVK_Space:
            let selectedRange = self.selectedRange()
            if let data = linkDataList.first(where: { data in
                return selectedRange == data.linkRange
            }) {
                if !data.linkAddress.isEmpty {
                    bHandled = true
                    self.openLinkCallBack?(data.linkAddress)
                }
            }
        case kVK_Tab:
            if event.modifierFlags.contains(.shift) {
                if keyTabEntry, let data = getPreviousTextViewHyperLinkDataClosestToSelectedRange() {
                    self.setSelectedRange(data.linkRange)
                    bHandled = true
                }
            } else {
                if let data = getNextTextViewHyperLinkDataClosestToSelectedRange() {
                    self.setSelectedRange(data.linkRange)
                    bHandled = true
                    keyTabEntry = true
                }
            }
        default:
            break
        }
        if !bHandled {
            super.keyDown(with: event)
        }
    }
    
    override public var frame: NSRect {
        didSet {
            self.linkDataList.forEach { data in
                let rect = boundingRectForRange(range: data.linkRange)
                data.linkRect = rect
            }
            self.needsDisplay = true
        }
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard target != nil else {
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
    }
    
    private func boundingRectForRange(range: NSRange) -> NSRect {
        guard let textStorage = self.textStorage else { return .zero }
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        
        var actualRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &actualRange)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: actualRange, in: textContainer)
        return NSRect(x: boundingRect.minX, y: boundingRect.minY, width: boundingRect.width + 4, height: boundingRect.height)
    }
    
    private func updateHyperLinks() {
        linkDataList = []
        let attrString = self.attributedString()
        let fullTextRange = NSRange(location: 0, length: attrString.length)
        
        attrString.enumerateAttribute(NSAttributedString.Key.link, in: fullTextRange, options: .longestEffectiveRangeNotRequired, using: {(value: Any?, range: NSRange, _ : UnsafeMutablePointer<ObjCBool>) -> Void in
            if let linkStr = value as? String {
                updateLinkTextAttributes(range: range, attrString: attrString, linkAddr: linkStr)
            }
            if let linkUrl = value as? NSURL, let linkStr = linkUrl.absoluteString {
                updateLinkTextAttributes(range: range, attrString: attrString, linkAddr: linkStr)
            }
        })
    }
    
    private func updateLinkTextAttributes(range: NSRange, attrString: NSAttributedString, linkAddr: String) {
        if let rangeInString = Range(range, in: attrString.string) {
            let textAtRange = String(self.string[rangeInString])
            if !self.linkDataList.contains(where: { data in
                return data.linkRange == range && data.linkText == textAtRange
            }) {
                self.linkDataList.append(ACRTextViewHyperLinkData(text: textAtRange, address: linkAddr, range: range))
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

protocol ACRTextViewResponderDelegate: AnyObject {
    func textViewDidBecomeFirstResponder()
    func textViewDidResignFirstResponder()
}
