import AppKit

enum ActionStyle: String {
    case positive
    case `default`
    case destructive
    case darkMode
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
        setupButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        setupButtonStyle()
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
        if config.isDarkMode {
            buttonActionStyle = .darkMode
        }
        buttonConfig = config.buttonConfig
        setupButtonStyle()
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
    
    private func setupButtonStyle() {
        // Common styling b/w all Action Style
        switch buttonActionStyle {
        case .default:
            // backgroundColor
            backgroundColor = buttonConfig.defaultButtonConfig.backgroundColor
            
            // borderColor
            borderColor = buttonConfig.defaultButtonConfig.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.defaultButtonConfig.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.defaultButtonConfig.buttonColor
            activeButtonColor = buttonConfig.defaultButtonConfig.activeButtonColor
            hoverButtonColor = buttonConfig.defaultButtonConfig.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.defaultButtonConfig.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.defaultButtonConfig.activeTextColor
            
        case .positive:
            // backgroundColor
            backgroundColor = buttonConfig.positiveButtonConfig.backgroundColor
            
            // borderColor
            borderColor = buttonConfig.positiveButtonConfig.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.positiveButtonConfig.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.positiveButtonConfig.buttonColor
            activeButtonColor = buttonConfig.positiveButtonConfig.activeButtonColor
            hoverButtonColor = buttonConfig.positiveButtonConfig.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.positiveButtonConfig.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.positiveButtonConfig.activeTextColor
            
        case .destructive:
            // backgroundColor
            backgroundColor = buttonConfig.destructiveButtonConfig.backgroundColor
            
            // borderColor
            borderColor = buttonConfig.destructiveButtonConfig.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.destructiveButtonConfig.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.destructiveButtonConfig.buttonColor
            activeButtonColor = buttonConfig.destructiveButtonConfig.activeButtonColor
            hoverButtonColor = buttonConfig.destructiveButtonConfig.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.destructiveButtonConfig.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.destructiveButtonConfig.activeTextColor
            
        case .inline:
            // backgroundColor
            backgroundColor = buttonConfig.inlineButtonConfig.backgroundColor
            
            // borderColor
            borderColor = buttonConfig.inlineButtonConfig.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.inlineButtonConfig.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.inlineButtonConfig.buttonColor
            activeButtonColor = buttonConfig.inlineButtonConfig.activeButtonColor
            hoverButtonColor = buttonConfig.inlineButtonConfig.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.inlineButtonConfig.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.inlineButtonConfig.activeTextColor
            
            contentInsets.left = 5
            contentInsets.right = 5
            
        case .darkMode:
            // backgroundColor
            backgroundColor = buttonConfig.darkThemeButtonConfig.backgroundColor
            
            // borderColor
            borderColor = buttonConfig.darkThemeButtonConfig.borderColor
            inActiveborderColor = borderColor
            activeBorderColor = buttonConfig.darkThemeButtonConfig.activeBorderColor
            
            // button color
            buttonColor = buttonConfig.darkThemeButtonConfig.buttonColor
            activeButtonColor = buttonConfig.darkThemeButtonConfig.activeButtonColor
            hoverButtonColor = buttonConfig.darkThemeButtonConfig.hoverButtonColor
            
            // textColor
            textColor = buttonConfig.darkThemeButtonConfig.textColor
            inActiveTextColor = textColor
            activeTextColor = buttonConfig.darkThemeButtonConfig.activeTextColor
        }
    }
}
