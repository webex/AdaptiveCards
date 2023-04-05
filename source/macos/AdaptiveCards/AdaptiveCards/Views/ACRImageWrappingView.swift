import AdaptiveCards_bridge
import AppKit
import Carbon.HIToolbox

class ACRImageWrappingView: NSView, SelectActionHandlingProtocol {
    private (set) var imageProperties: ACRImageProperties?
    private (set) weak var contentImageView: NSImageView?
    var target: TargetHandler?
    var isImageSet = false
    var isPersonStyle = false
    private var previousBackgroundColor: CGColor?
    private var cursorType = NSCursor.arrow
    private var canAcceptFirstResponder: Bool {
        return target != nil
    }
    
    override var acceptsFirstResponder: Bool {
        return canAcceptFirstResponder
    }
    
    override var canBecomeKeyView: Bool {
        return canAcceptFirstResponder
    }
    
    override public var focusRingMaskBounds: NSRect {
        return isImageSet ? self.contentImageView?.bounds ?? self.bounds : self.bounds
    }
    
    override public func drawFocusRingMask() {
        if target != nil {
            if isImageSet, let contentView = self.contentImageView {
                contentView.bounds.fill()
            } else {
                self.bounds.fill()
            }
            self.needsDisplay = true
        }
    }
    
    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: cursorType)
    }
    
    init(imageProperties: ACRImageProperties, imageView: NSImageView) {
        let frame = CGRect(x: 0, y: 0, width: imageProperties.contentSize.width, height: imageProperties.contentSize.height)
        super.init(frame: frame)
        needsLayout = true
        self.imageProperties = imageProperties
        self.contentImageView = imageView
        self.addSubview(imageView)
        setupTrackingArea()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layout() {
        super.layout()
        if isPersonStyle, let subview = subviews.first {
            let maskLayer = CAShapeLayer()
            maskLayer.path = CGPath(ellipseIn: subview.bounds, transform: nil)
            subview.wantsLayer = true
            subview.layer?.mask = maskLayer
            subview.layer?.masksToBounds = true
        }
    }
    
    override var intrinsicContentSize: NSSize {
        guard let size = imageProperties?.contentSize else {
            return super.intrinsicContentSize
        }
        return size.width > 0 ? size : super.intrinsicContentSize
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let hasExpilicitDimension = imageProperties?.hasExplicitDimensions, !hasExpilicitDimension else { return }
        setWidthConstraintWithSuperView()
    }
    
    private func setWidthConstraintWithSuperView() {
        guard let superView = self.superview else { return }
        if isImageSet {
            // when actual image or its dimensions are available
            if imageProperties?.acsImageSize != .stretch {
                widthAnchor.constraint(greaterThanOrEqualTo: superView.widthAnchor).isActive = true
            } else {
                widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
            }
        } else {
            widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
        }
    }
    
    func update(imageProperties: ACRImageProperties) {
        self.imageProperties = imageProperties
        self.invalidateIntrinsicContentSize()
    }
    
    override func keyDown(with event: NSEvent) {
        if Int(event.keyCode) == kVK_Space {
            target?.handleSelectionAction(for: self)
        } else {
            super.keyDown(with: event)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        guard let target = target else { return }
        target.handleSelectionAction(for: self)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard target != nil, frame.contains(point) else { return super.hitTest(point) }
        return self
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    /// set the cursor type while the image hovering and the select action is active
    /// - Parameter cursor: accept cursor type
    private func setCursorType(cursor: NSCursor) {
        cursorType = cursor
        resetCursorRects()
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let columnView = event.trackingArea?.owner as? ACRImageWrappingView, target != nil else { return }
        previousBackgroundColor = columnView.layer?.backgroundColor
        columnView.layer?.backgroundColor = ColorUtils.hoverColorOnMouseEnter().cgColor
        // Added a pointing hand here
        self.setCursorType(cursor: .pointingHand)
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let columnView = event.trackingArea?.owner as? ACRImageWrappingView, target != nil else { return }
        columnView.layer?.backgroundColor = previousBackgroundColor ?? .clear
        // Back to the system cursor
        self.setCursorType(cursor: .current)
    }
}
