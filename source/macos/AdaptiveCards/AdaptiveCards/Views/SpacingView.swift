import AdaptiveCards_bridge
import AppKit

class SpacingView: NSView {
    var orientation: NSUserInterfaceLayoutOrientation
    var lineWidth: CGFloat
    var lineColor: NSColor
    var spacing: CGFloat
    
    override init(frame frameRect: NSRect) {
        orientation = .horizontal
        lineColor = .clear
        lineWidth = .zero
        spacing = .zero
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Create New Spacer
    /// - Parameters:
    ///   - elem: BaseCard Element
    ///   - view: Superview of basecard element
    ///   - config: Host Config
    /// - Returns: Spacer
    class func renderSpacer(elem: ACSBaseCardElement, forSuperView view: ACRContentStackView, withHostConfig config: ACSHostConfig) -> SpacingView? {
        let separator = SpacingView()
        let requestedSpacing = elem.getSpacing()
        if requestedSpacing != .none {
            separator.orientation = view.orientation
            let spacing = HostConfigUtils.getSpacing(requestedSpacing, with: config).doubleValue
            separator.spacing = spacing
            if elem.getSeparator() {
                let seperatorConfig = config.getSeparator()
                let lineThickness = seperatorConfig?.lineThickness ?? 1
                let lineColor = seperatorConfig?.lineColor
                separator.lineColor = ColorUtils.color(from: lineColor ?? "#EEEEEE") ?? .white
                separator.lineWidth = CGFloat(lineThickness.floatValue)
            }
            separator.layer?.backgroundColor = .clear
            view.addArrangedSubview(separator)
            separator.configConstraintLayout()
        }
        return separator
    }
    
    func configConstraintLayout() {
        if orientation == .horizontal {
            let widthAnchor = widthAnchor.constraint(equalToConstant: spacing)
            widthAnchor.isActive = true
        } else {
            let heightAnchor = heightAnchor.constraint(equalToConstant: spacing)
            heightAnchor.isActive = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let rect = dirtyRect
        var orig: CGPoint
        var dest: CGPoint
        if orientation == .vertical {
            orig = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height / 2.0)
            dest = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height / 2.0)
        } else {
            orig = CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y)
            dest = CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y + rect.size.height)
        }
        lineColor.setStroke()
        let path = NSBezierPath()
        path.move(to: orig)
        path.line(to: dest)
        path.lineWidth = lineWidth
        path.stroke()
    }
}
