import AppKit

enum ActionStyle: String {
    case positive
    case `default`
    case destructive
}

class ACRButton: FlatButton {
    public var backgroundColor: NSColor = .init(red: 0.35216, green: 0.823529412, blue: 1, alpha: 1)
    public var hoverBackgroundColor: NSColor = .linkColor
    public var activeBackgroundColor: NSColor = .linkColor
    
    private var inActiveTextColor: NSColor = .linkColor
    private var inActiveborderColor: NSColor = .linkColor
    private var hoverButtonColor: NSColor = .linkColor
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        initialize()
        setupButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        setupButtonStyle()
    }
    
    init(frame: NSRect = .zero, wantsChevron: Bool = false, wantsIcon: Bool = false, iconNamed: String = "", iconPosition: NSControl.ImagePosition = .imageLeft, style: ActionStyle = .default) {
        super.init(frame: frame)
        if wantsChevron {
            showsChevron = wantsChevron
        }
        if wantsIcon {
            showsIcon = wantsIcon
            iconImageName = iconNamed
            iconPositioned = iconPosition
        }
        initialize()
        setupButtonStyle(style: style)
    }
    
    private func initialize() {
        borderWidth = 1
        onAnimationDuration = 0.0
        offAnimationDuration = 0.0
        iconColor = NSColor.white
        activeIconColor = NSColor.white
        momentary = !showsChevron
        iconColor = .white
        if showsIcon {
            guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards"),
                  let path = bundle.path(forResource: iconImageName, ofType: "png") else {
                logError("Image Not Found")
                return
            }
            image = NSImage(byReferencing: URL(fileURLWithPath: path))
            imagePosition = iconPositioned
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override open func layout() {
        super.layout()
        cornerRadius = bounds.height / 2
    }

    override open func mouseEntered(with event: NSEvent) {
        buttonColor = hoverButtonColor
        borderColor = activeBorderColor
        textColor = activeTextColor
        super.mouseEntered(with: event)
    }
    
    override open func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        buttonColor = backgroundColor
        borderColor = inActiveborderColor
        textColor = inActiveTextColor
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        buttonColor = activeButtonColor
        borderColor = activeBorderColor
        textColor = activeTextColor
    }
    
    private func setupButtonStyle(style: ActionStyle = .default) {
        // Common styling b/w all Action Style
        backgroundColor = .white
        buttonColor = .white
        activeTextColor = .white
        
        let buttonStyle = style
        
        switch buttonStyle {
        case .default:
            // borderColor
            borderColor = ColorUtils.color(from: "#007EA8") ?? .clear
            inActiveborderColor = borderColor
            activeBorderColor = ColorUtils.color(from: "#0A5E7D") ?? .clear
            
            // button color
            activeButtonColor = ColorUtils.color(from: "#0A5E7D") ?? .clear
            hoverButtonColor = ColorUtils.color(from: "#007EA8") ?? .clear
            
            // textColor
            textColor = ColorUtils.color(from: "#007EA8") ?? .white
            inActiveTextColor = textColor
            
        case .positive:
            // borderColor
            borderColor = ColorUtils.color(from: "#1B8728") ?? .clear
            inActiveborderColor = borderColor
            activeBorderColor = ColorUtils.color(from: "#196323") ?? .clear
            
            // button color
            activeButtonColor = ColorUtils.color(from: "#1B8728") ?? .clear
            hoverButtonColor = ColorUtils.color(from: "#1B8728") ?? .clear
            
            // textColor
            textColor = ColorUtils.color(from: "#1B8728") ?? .white
            inActiveTextColor = textColor
            
        case .destructive:
            // borderColor
            borderColor = ColorUtils.color(from: "#D93829") ?? .clear
            inActiveborderColor = borderColor
            activeBorderColor = ColorUtils.color(from: "#A12C23") ?? .clear
            
            // button color
            activeButtonColor = ColorUtils.color(from: "#A12C23") ?? .clear
            hoverButtonColor = ColorUtils.color(from: "#D93829") ?? .clear
            
            // textColor
            textColor = ColorUtils.color(from: "#D93829") ?? .white
            inActiveTextColor = textColor
        }
    }
}
