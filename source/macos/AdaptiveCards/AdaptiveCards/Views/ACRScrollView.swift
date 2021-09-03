import AppKit

class ACRScrollView: NSScrollView {
    var disableScroll = false
    
    override func scrollWheel(with event: NSEvent) {
        if !disableScroll {
            super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
    override open func drawFocusRingMask() {
        let path = NSBezierPath(roundedRect: self.bounds, xRadius: self.layer?.cornerRadius ?? 0, yRadius: self.layer?.cornerRadius ?? 0)
        path.fill()
    }
}
