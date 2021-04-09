import AppKit

enum ActionStyle: String {
    case positive
    case `default`
    case destructive
    case inline
}

class ACRButton: FlatButton, ImageHoldingView {
    public var backgroundColor: NSColor = .clear
    
    private var inActiveTextColor: NSColor = .linkColor
    private var inActiveborderColor: NSColor = .linkColor
    private var hoverButtonColor: NSColor = .linkColor
    private var buttonActionStyle: ActionStyle = .default
    private var buttonConfig: ButtonConfig = .default
        
    override init(frame: NSRect) {
        super.init(frame: frame)
        initialize()
        setupButtonStyle(style: .default, buttonConfig: .default)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        setupButtonStyle(style: .default, buttonConfig: .default)
    }
    
    init(frame: NSRect = .zero, wantsChevron: Bool = false, wantsIcon: Bool = false, iconNamed: String = "", iconImageFileType: String = "", iconPosition: NSControl.ImagePosition = .imageLeft, style: ActionStyle = .default, config: RenderConfig = .default) {
        super.init(frame: frame)
        if wantsChevron {
            showsChevron = wantsChevron
        }
        if wantsIcon {
            showsIcon = wantsIcon
            iconImageName = iconNamed
            iconFileType = iconImageFileType
            iconPositioned = iconPosition
        }
        initialize()
        buttonActionStyle = style
        setupButtonStyle(style: style, buttonConfig: config.buttonConfig)
    }
    
    private func initialize() {
        borderWidth = 1
        onAnimationDuration = 0.0
        offAnimationDuration = 0.0
        momentary = !showsChevron
        if showsIcon {
            image = BundleUtils.getImage(iconImageName, ofType: iconFileType)
            imagePosition = iconPositioned
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override open func layout() {
        super.layout()
        if buttonActionStyle != .inline {
            cornerRadius = bounds.height / 2
        }
    }
    
    func setImage(_ image: NSImage) {
        iconColor = NSColor(patternImage: image)
        activeIconColor = iconColor
        self.image = image
        mouseExited(with: NSEvent()) // this is to force trigger the event for image updation
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
    
    private func setupButtonStyle(style: ActionStyle, buttonConfig: ButtonConfig) {
        // Common styling b/w all Action Style
        switch buttonActionStyle {
        case .default:
            // backgroundColor
            backgroundColor = buttonConfig.default.buttonColor
            
            // borderColor
            borderColor = buttonConfig.default.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.default.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.default.buttonColor
            activeButtonColor = buttonConfig.default.activeButtonColor
            hoverButtonColor = buttonConfig.default.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.default.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.default.activeTextColor
            
        case .positive:
            // backgroundColor
            backgroundColor = buttonConfig.positive.buttonColor
            
            // borderColor
            borderColor = buttonConfig.positive.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.positive.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.positive.buttonColor
            activeButtonColor = buttonConfig.positive.activeButtonColor
            hoverButtonColor = buttonConfig.positive.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.positive.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.positive.activeTextColor
            
        case .destructive:
            // backgroundColor
            backgroundColor = buttonConfig.destructive.buttonColor
            
            // borderColor
            borderColor = buttonConfig.destructive.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.destructive.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.destructive.buttonColor
            activeButtonColor = buttonConfig.destructive.activeButtonColor
            hoverButtonColor = buttonConfig.destructive.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.destructive.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.destructive.activeTextColor
            
        case .inline:
            // backgroundColor
            backgroundColor = buttonConfig.inline.buttonColor
            
            // borderColor
            borderColor = buttonConfig.inline.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.inline.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.inline.buttonColor
            activeButtonColor = buttonConfig.inline.activeButtonColor
            hoverButtonColor = buttonConfig.inline.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.inline.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.inline.activeTextColor
            
            contentInsets.left = 5
            contentInsets.right = 5
        }
    }
}
