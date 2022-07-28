import AdaptiveCards_bridge
import AppKit

protocol ACRContentHoldingViewProtocol {
    func addArrangedSubview(_ subview: NSView)
    func insertArrangedSubview(_ view: NSView, at insertionIndex: Int)
    func updateLayoutOfRenderedView(_ renderedView: NSView?, acoElement acoElem: ACSBaseCardElement?, separator: SpacingView?, rootView: ACRView?)
    func configureLayout(_ verticalContentAlignment: ACSVerticalContentAlignment, minHeight: NSNumber, heightType: ACSHeightType, type: ACSCardElementType)
    func applyPadding(_ padding: CGFloat)
}

class ACRContentStackView: NSView, ACRContentHoldingViewProtocol, SelectActionHandlingProtocol {
    private var stackViewLeadingConstraint: NSLayoutConstraint?
    private var stackViewTrailingConstraint: NSLayoutConstraint?
    private var stackViewTopConstraint: NSLayoutConstraint?
    private var stackViewBottomConstraint: NSLayoutConstraint?
    
    private (set) var currentSpacingView: SpacingView? // made as set for use in test
    private var currentSeparatorView: SpacingView?
    private (set) var errorMessageField: NSTextField?
    private (set) var inputLabelField: NSTextField?
    
    let style: ACSContainerStyle
    let hostConfig: ACSHostConfig
    let renderConfig: RenderConfig
    var target: TargetHandler?
    public var bleed = false
    private let paddingHandler = ACSFillerSpaceManager()
    private var verticalContentAlignment: ACSVerticalContentAlignment = .top
    private var paddings = [NSView]()
    // Store the Intrinsic size of subviews
    private var subviewIntrinsicContentSizeCollection: [String: NSValue] = [String: NSValue]()
    // Hold self view dynamic content intrinsicSize
    var combinedContentSize: CGSize = .zero
    
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
        view.distribution = .fill
        return view
    }()
    
    var hasStretchableView: Bool {
        return paddingHandler.hasPadding()
    }
    
    // Use intrinsicContentSize, work with hugging priority and autolayout. won't work as expected resluts without it.
    override var intrinsicContentSize: NSSize {
        return self.combinedContentSize
    }
    
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
    
    func insertArrangedSubview(_ view: NSView, at insertionIndex: Int) {
        stackView.insertArrangedSubview(view, at: insertionIndex)
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
    
    // use this method if a subview to the content stack view needs a padding
    // use configureHeightFor for all cases except when stretching the subview
    // is not desirable.
    
    func addPadding(for view: NSView) -> NSView {
        return paddingHandler.addPadding(forView: view)
    }
    
    // it simply adds padding to the top and bottom of contents of the content stack view
    // according to vertical alignment
    
    func addPadding() {
        if self.verticalContentAlignment == .center || self.verticalContentAlignment == .bottom {
            let padding = self.addPadding(for: self)
            self.paddings.append(padding)
            self.insertArrangedSubview(padding, at: 0)
        }
        if self.verticalContentAlignment == .center || self.verticalContentAlignment == .top {
            let padding = self.addPadding(for: self)
            self.paddings.append(padding)
            self.addArrangedSubview(padding)
        }
    }
    
    func increaseIntrinsicContentSize(_ view: NSView) {
        let key = String(format: "%p", view)
        subviewIntrinsicContentSizeCollection[key] = NSValue(size: view.intrinsicContentSize)
    }
    
    func decreaseIntrinsicContentSize(_ view: NSView) {
        // This Empty function design for override methods
    }
    
    func updateIntrinsicContentSize() {
        // This Empty function design for override methods
    }
    
    func updateIntrinsicContentSize(_ block: @escaping (_ view: Any, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>) -> Void) {
        (stackView.arrangedSubviews as NSArray).enumerateObjects(block)
    }
    
    func getMaxHeightOfSubviews(afterExcluding view: NSView?) -> CGFloat {
        return getViewWithMaxDimension(
            afterExcluding: view,
            dimension: { [self] vw in
                var key: String?
                if let vw = vw {
                    key = String(format: "%p", vw)
                }
                let value = self.subviewIntrinsicContentSizeCollection[key ?? ""]
                return (value != nil ? value?.sizeValue : .zero)?.height ?? 0.0
            })
    }
    
    func getMaxWidthOfSubviews(afterExcluding view: NSView?) -> CGFloat {
        return getViewWithMaxDimension(
            afterExcluding: view,
            dimension: { [self] vw in
                var key: String?
                if let vw = vw {
                    key = String(format: "%p", vw)
                }
                let value = self.subviewIntrinsicContentSizeCollection[key ?? ""]
                return (value != nil ? value?.sizeValue : .zero)?.width ?? 0.0
            })
    }
    
    func getViewWithMaxDimension(afterExcluding view: NSView?, dimension: @escaping (_ view: NSView?) -> CGFloat) -> CGFloat {
        var currentBest: CGFloat = 0.0
        self.stackView.arrangedSubviews.forEach { vw in
            if vw.isNotEqual(to: view) {
                currentBest = CGFloat(max(currentBest, dimension(vw)))
            }
        }
        return currentBest
    }
    
    func getIntrinsicContentSize(inArragedSubviews view: NSView) -> NSSize {
        let key = String(format: "%p", view)
        let value = subviewIntrinsicContentSizeCollection[key]
        return value?.sizeValue ?? .zero
    }
    
    /// this function will tell if the content stack view should have a padding
    /// padding will be added if
    /// none of its subviews is stretchable or has padding and there is at least
    /// one visible view.
    /// the content stack view has hasStrechableView property, but getting the property value
    /// has cost, so added the hasStretcahbleView parameter to reduce the number of call to
    /// the property value.
    /// todo part : add visiblity checking for stretchable view.
    
    func shouldAddPadding(_ hasStretchableView: Bool) -> Bool {
        return !hasStretchableView
    }
    
    /// call this method after subview is rendered
    /// it configures height, creates association between the subview and its separator if any
    /// registers subview for its visibility
    func updateLayoutOfRenderedView(_ renderedView: NSView?, acoElement acoElem: ACSBaseCardElement?, separator: SpacingView?, rootView: ACRView?) {
        guard let renderedView = renderedView, let acoElem = acoElem else { return }
        self.configureHeight(for: renderedView, acoElement: acoElem)
    }
    
    func configureHeight(for view: NSView?, acoElement element: ACSBaseCardElement?) {
        guard let view = view, let element = element else { return }
        self.paddingHandler.configureHeight(view: view, correspondingElement: element)
    }
    
    /// call this method once all subviews are rendered
    /// this methods add padding to itself for alignment and stretch
    /// apply visibility to subviews
    /// configure min height
    /// then activate all contraints associated with the configuration.
    /// activation constraint all at once is more efficient than activating
    /// constraints one by one.
    
    func configureLayout(_ verticalContentAlignment: ACSVerticalContentAlignment, minHeight: NSNumber, heightType: ACSHeightType, type: ACSCardElementType) {
        self.verticalContentAlignment = verticalContentAlignment
        if self.shouldAddPadding(self.hasStretchableView) {
            self.addPadding()
        }
        self.setMinimumHeight(minHeight)
        paddingHandler.activateConstraintsForPadding()
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
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
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
        let constraint = NSLayoutConstraint(
           item: self,
           attribute: .height,
           relatedBy: .greaterThanOrEqual,
           toItem: nil,
           attribute: .notAnAttribute,
           multiplier: 1,
           constant: heightPt)
        constraint.priority = NSLayoutConstraint.Priority(rawValue: 999)
        constraint.isActive = true
    }
    
    func refreshOnVisibilityChange(from isHiddenOld: Bool) {
        guard let stackView = superview as? NSStackView else { return }
        
        if isHidden {
             // if an object is hidden then we need to update the visibility of spacing view of the adjacent nonHidden object
             guard let toggledView = (stackView.arrangedSubviews.first { !$0.isHidden && !($0 is SpacingView) }) as? ACRContentStackView  else { return }
             toggledView.currentSpacingView?.isHidden = true
             toggledView.currentSeparatorView?.isHidden = true
         } else {
             // Spacer and Separator to be hidden only if this view is the first element of the parent stack
             // Ignore all Spacing to check firstElement, as they're added for `verticalContentAlignment`. Refer ContainerRenderer / ColumnRenderer.
             
             guard let toggledView = (stackView.arrangedSubviews.first { !$0.isHidden && !($0 is SpacingView) }) else { return }
             let isFirstElement = toggledView == self
             currentSpacingView?.isHidden = isFirstElement
             currentSeparatorView?.isHidden = isFirstElement

             // once we toggle any object to visibility , we need to see if the objects in series next to toggled one were already being shown or not . if shown we need to update the currentSpacingView of those items to false
             
             guard stackView.arrangedSubviews.count > 1 else { return }
             // getting index of the toggled object
             guard let toggledViewIndex = stackView.arrangedSubviews.firstIndex(of: toggledView) else { return }

             // if toggled element is last one no need to continue
             guard toggledViewIndex < stackView.arrangedSubviews.count - 1 else { return }
             
             // if next view in sequence is not hidden set its currentSpacingView?.isHidden to false
             for index in toggledViewIndex + 1..<stackView.arrangedSubviews.count {
                 if let nextView = stackView.arrangedSubviews[index] as? ACRContentStackView, !nextView.isHidden {
                     nextView.currentSpacingView?.isHidden = false
                     nextView.currentSeparatorView?.isHidden = false
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
