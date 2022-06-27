import AdaptiveCards_bridge
import AppKit

protocol ACRContentHoldingViewProtocol {
    func addArrangedSubview(_ subview: NSView)
    func applyPadding(_ padding: CGFloat)
}

class ACRContentStackView: NSView, ACRContentHoldingViewProtocol, SelectActionHandlingProtocol {
    private var stackViewLeadingConstraint: NSLayoutConstraint?
    private var stackViewTrailingConstraint: NSLayoutConstraint?
    private var stackViewTopConstraint: NSLayoutConstraint?
    private var stackViewBottomConstraint: NSLayoutConstraint?
    
    private var currentSpacingView: SpacingView?
    private var currentSeparatorView: SpacingView?
    private (set) var errorMessageField: NSTextField?
    private (set) var inputLabelField: NSTextField?
    
    let style: ACSContainerStyle
    let hostConfig: ACSHostConfig
    let renderConfig: RenderConfig
    var target: TargetHandler?
    public var bleed = false
    
    public var orientation: NSUserInterfaceLayoutOrientation {
        get { return stackView.orientation }
        set {
            stackView.orientation = newValue
            stackView.alignment = newValue == .horizontal ? .top : .leading
        }
    }
    
    public var alignment: NSLayoutConstraint.Attribute {
        get { return stackView.alignment }
        set { stackView.alignment = newValue }
    }
    
    public var distribution: NSStackView.Distribution {
        get { return stackView.distribution }
        set { stackView.distribution = newValue }
    }
    
    public var arrangedSubviews: [NSView] {
        return stackView.arrangedSubviews
    }
    
    private (set) lazy var stackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.alignment = .leading
        view.spacing = 0
        return view
    }()
    
    init(style: ACSContainerStyle, hostConfig: ACSHostConfig, renderConfig: RenderConfig) {
        self.hostConfig = hostConfig
        self.style = style
        self.renderConfig = renderConfig
        super.init(frame: .zero)
        initialize()
    }
    
    init(style: ACSContainerStyle, parentStyle: ACSContainerStyle?, hostConfig: ACSHostConfig, renderConfig: RenderConfig, superview: NSView?, needsPadding: Bool) {
        self.hostConfig = hostConfig
        self.style = style
        self.renderConfig = renderConfig
        super.init(frame: .zero)
        initialize()
        if needsPadding {
            if let bgColor = hostConfig.getBackgroundColor(for: style) {
                layer?.backgroundColor = bgColor.cgColor
            }
        /* Experimental Feature
            // set border color
            if let borderColorHex = hostConfig.getBorderColor(style), let borderColor = ColorUtils.color(from: borderColorHex) {
                layer?.borderColor = borderColor.cgColor
            }
            // set border width
            if let borderWidth = hostConfig.getBorderThickness(style) {
                layer?.borderWidth = CGFloat(truncating: borderWidth)
            }
        */
            // add padding
            if let paddingSpace = hostConfig.getSpacing()?.paddingSpacing, let padding = CGFloat(exactly: paddingSpace) {
                applyPadding(padding)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        self.hostConfig = ACSHostConfig() // TODO: This won't work
        self.style = .none
        self.renderConfig = .default
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        wantsLayer = true
        if !(self is ACRView) { // RootView should support clipping
            layer = NoClippingLayer()
        }
        setupViews()
        setupConstraints()
        setupTrackingArea()
    }
    
    func addArrangedSubview(_ subview: NSView) {
        stackView.addArrangedSubview(subview)
    }
    
    func addView(_ view: NSView, in gravity: NSStackView.Gravity) {
        stackView.addView(view, in: gravity)
    }
    
    func applyPadding(_ padding: CGFloat) {
        stackViewLeadingConstraint?.constant = padding
        stackViewTopConstraint?.constant = padding
        stackViewTrailingConstraint?.constant = -padding
        stackViewBottomConstraint?.constant = -padding
    }
    
    func setBleedProp(top: Bool, bottom: Bool, trailing: Bool, leading: Bool) {
        if top {
            stackViewTopConstraint?.constant = 0
        }
        if bottom {
            stackViewBottomConstraint?.constant = 0
        }
        if leading {
            stackViewLeadingConstraint?.constant = 0
        }
        if trailing {
            stackViewTrailingConstraint?.constant = 0
        }
    }
    
    func addSeperator(_ separator: Bool) {
        guard separator else { return }
        let seperatorConfig = hostConfig.getSeparator()
        let lineThickness = seperatorConfig?.lineThickness
        let lineColor = seperatorConfig?.lineColor
        addSeperator(thickness: lineThickness ?? 1, color: lineColor ?? "#EEEEEE")
    }
    
    func addSpacing(_ spacing: ACSSpacing) {
        let spaceAdded = HostConfigUtils.getSpacing(spacing, with: hostConfig)
        addSpacing(spacing: CGFloat(truncating: spaceAdded))
    }
    
    func setCustomSpacing(spacing: CGFloat, after view: NSView) {
        stackView.setCustomSpacing(spacing, after: view)
    }
    
    private func addSeperator(thickness: NSNumber, color: String) {
        let seperatorView = SpacingView(asSeparatorViewWithThickness: CGFloat(truncating: thickness), color: color, orientation: orientation)
        stackView.addArrangedSubview(seperatorView)
        stackView.setCustomSpacing(5, after: seperatorView)
        currentSeparatorView = seperatorView
    }
    
    private func addSpacing(spacing: CGFloat) {
        let spacingView = SpacingView(orientation: orientation, spacing: spacing)
        stackView.addArrangedSubview(spacingView)
        currentSpacingView = spacingView
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    /// This method can be overridden, but not to be called from anywhere
    func setupViews() {
        addSubview(stackView)
    }
    
    /// This method can be overridden, but not to be called from anywhere
    func setupConstraints() {
        stackViewLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        stackViewTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: topAnchor)
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        guard let leading = stackViewLeadingConstraint, let trailing = stackViewTrailingConstraint, let top = stackViewTopConstraint, let bottom = stackViewBottomConstraint else { return }
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        stackView.setHuggingPriority(.fittingSizeCompression, for: .vertical)
        stackView.setContentHuggingPriority(.fittingSizeCompression, for: .vertical)
    }
    
    /// This method can be overridden, but not to be called from anywhere
    func anchorBottomConstraint(with anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        stackViewBottomConstraint?.isActive = false
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: anchor)
        stackViewBottomConstraint?.isActive = true
    }
    
    /// This methid can be overridden. super implementation must be called
    func hideErrorMessage(with currentFocussedView: NSView?) {
        errorMessageField?.isHidden = true
    }
    
    func setVerticalHuggingPriority(_ rawValue: Float) {
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue), for: .vertical)
    }
    
    func setMinimumHeight(_ height: NSNumber?) {
        guard let height = height, let heightPt = CGFloat(exactly: height), heightPt > 0 else { return }
        heightAnchor.constraint(greaterThanOrEqualToConstant: heightPt).isActive = true
    }
    
    func refreshOnVisibilityChange(from isHiddenOld: Bool) {
        // Ignore refresh if view is isHidden or state is not changed
        // Ignore refresh if view is not inside a stackView
        guard !isHidden, isHidden != isHiddenOld, let stackView = superview as? NSStackView else { return }
        
        // Spacer and Separator to be hidden only if this view is the first element of the parent stack
        // Ignore all Spacing to chack firstElement, as they're added for `verticalContentAlignment`. Refer ContainerRenderer / ColumnRenderer.
        guard let toggledView = (stackView.arrangedSubviews.first { !$0.isHidden && !($0 is SpacingView) }) else { return }
        let isFirstElement = toggledView == self
        currentSpacingView?.isHidden = isFirstElement
        currentSeparatorView?.isHidden = isFirstElement
        
        // once we toggle any object to visibility , we need to see if the objects in series next to toggled one were already being shown or not . if shown we need to update the currentSpacingView of those items to false
        
        if stackView.arrangedSubviews.count > 1 {
            // getting index of the toggled object
            guard let toggledViewIndex = stackView.arrangedSubviews.firstIndex(of: toggledView) else { return }
            
            // if toggled element is last one no need to continue
            if toggledViewIndex < stackView.arrangedSubviews.count - 1 {
                // if next view in sequence is not hidden set its currentSpacingView?.isHidden to false
                for index in toggledViewIndex + 1..<stackView.arrangedSubviews.count {
                    if let nextView = stackView.arrangedSubviews[index] as? ACRContentStackView, !nextView.isHidden {
                        nextView.currentSpacingView?.isHidden = false
                        nextView.currentSeparatorView?.isHidden = false
                    }
                }
            }
        }
    }
    
    // MARK: Mouse Events and SelectAction logics
    private var previousBackgroundColor: CGColor?
    override func mouseEntered(with event: NSEvent) {
        guard target != nil else { return }
        previousBackgroundColor = layer?.backgroundColor
        layer?.backgroundColor = ColorUtils.hoverColorOnMouseEnter().cgColor
    }
    
    private func staticTextField() -> NSTextField {
        let textField = NSTextField()
        textField.allowsEditingTextAttributes = true
        textField.isEditable = false
        textField.isBordered = false
        textField.isSelectable = true
        textField.setAccessibilityRole(.none)
        textField.backgroundColor = .clear
        return textField
    }
    
    func configureInputElements(element: ACSBaseInputElement, view: NSView) {
        setupLabel(for: element)
        addArrangedSubview(view)
        if view is ACRContentStackView {
            view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        setupErrorMessage(element: element, view: view)
    }
    
    private func setupLabel(for element: ACSBaseInputElement) {
        guard renderConfig.supportsSchemeV1_3, let label = element.getLabel(), !label.isEmpty, inputLabelField?.stringValue != label else { return }
        let attributedString = NSMutableAttributedString(string: label)
        let errorStateConfig = renderConfig.inputFieldConfig.errorStateConfig
        let isRequiredSuffix = (hostConfig.getInputs()?.label.requiredInputs.suffix ?? "").isEmpty ? "*" : hostConfig.getInputs()?.label.requiredInputs.suffix ?? "*"
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor, .font: NSFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: attributedString.length))
        }
        if element.getIsRequired() {
            attributedString.append(NSAttributedString(string: " " + isRequiredSuffix, attributes: [.foregroundColor: errorStateConfig.textColor, .font: NSFont.systemFont(ofSize: 16)]))
        }
        let labelView = staticTextField()
        labelView.attributedStringValue = attributedString
        addArrangedSubview(labelView)
        setCustomSpacing(spacing: 3, after: labelView)
        inputLabelField = labelView
    }
    
    private func setupErrorMessage(element: ACSBaseInputElement, view: NSView) {
        guard renderConfig.supportsSchemeV1_3, let view = view as? InputHandlingViewProtocol, let errorMessage = element.getErrorMessage(), !errorMessage.isEmpty, errorMessageField?.stringValue != errorMessage else { return }
        let attributedErrorMessageString = NSMutableAttributedString(string: errorMessage)
        let errorStateConfig = renderConfig.inputFieldConfig.errorStateConfig
        attributedErrorMessageString.addAttributes([.font: errorStateConfig.font, .foregroundColor: errorStateConfig.textColor], range: NSRange(location: 0, length: attributedErrorMessageString.length))
        setCustomSpacing(spacing: 5, after: view)
        let errorField = staticTextField()
        errorField.isHidden = true
        errorField.attributedStringValue = attributedErrorMessageString
        view.errorDelegate = self
        addArrangedSubview(errorField)
        errorMessageField = errorField
    }
    
    override func mouseExited(with event: NSEvent) {
        guard target != nil else { return }
        layer?.backgroundColor = previousBackgroundColor ?? .clear
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
}

extension ACRContentStackView: InputHandlingViewErrorDelegate {
    func inputHandlingViewShouldShowError(_ view: InputHandlingViewProtocol) {
        errorMessageField?.isHidden = false
    }
    
    func inputHandlingViewShouldHideError(_ view: InputHandlingViewProtocol, currentFocussedView: NSView?) {
        hideErrorMessage(with: currentFocussedView)
    }
    
    func inputHandlingViewShouldAnnounceErrorMessage(_ view: InputHandlingViewProtocol, message: String?) {
        let errorMessagePrefixString = renderConfig.localisedStringConfig.errorMessagePrefixString + ", "
        let errorMessageString = (errorMessageField?.stringValue ?? "") + ". "
        let labelString = (inputLabelField?.stringValue ?? "") + ". "
        let announcementString = message ?? (errorMessagePrefixString + errorMessageString + labelString)
        NSAccessibility.announce(announcementString)
    }
    
    var isErrorVisible: Bool {
        return !(errorMessageField?.isHidden ?? true)
    }
}

class NoClippingLayer: CALayer {
    override var masksToBounds: Bool {
        get { return false }
        set { }
    }
}
