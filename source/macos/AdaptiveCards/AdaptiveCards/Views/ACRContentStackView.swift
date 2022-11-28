import AdaptiveCards_bridge
import AppKit

protocol ACRContentHoldingViewProtocol {
    func addArrangedSubview(_ subview: NSView)
    func insertArrangedSubview(_ view: NSView, at insertionIndex: Int)
    func updateLayoutAndVisibilityOfRenderedView(_ renderedView: NSView, acoElement acoElem: ACSBaseCardElement, separator: SpacingView?, rootView: ACRView?)
    func configureLayoutAndVisibility(element: NSObject, isRootMinHeightAvailable: Bool)
    func applyPadding(_ padding: CGFloat)
}

class ACRContentStackView: NSView, ACRContentHoldingViewProtocol, SelectActionHandlingProtocol {
    private var stackViewLeadingConstraint: NSLayoutConstraint?
    private var stackViewTrailingConstraint: NSLayoutConstraint?
    private var stackViewTopConstraint: NSLayoutConstraint?
    private var stackViewBottomConstraint: NSLayoutConstraint?
    
    // map table store errror message field
    private let errorMessageFieldMap = NSMapTable<NSString, ACRInputErrorTextField>(keyOptions: .strongMemory, valueOptions: .weakMemory)
    // map table store input label field
    private let inputLabelFieldMap = NSMapTable<NSString, ACRInputLabelTextField>(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    let style: ACSContainerStyle
    let hostConfig: ACSHostConfig
    let renderConfig: RenderConfig
    var target: TargetHandler?
    public var bleed = false
    private let visibilityManager = ACSVisibilityManager()
    private var verticalContentAlignment: ACSVerticalContentAlignment = .top {
        didSet {
            if self.verticalContentAlignment != .top {
                // temporary fix to avoid regression.
                // Plan to make vertical content alignment work with gravity areas hence removing dependency with padding
                addPadding()
            }
        }
    }
    private var paddings = [NSView]()
    private let invisibleViews = NSMutableSet()
    // Store the Intrinsic size of subviews
    private var subviewIntrinsicContentSizeCollection: [String: NSValue] = [String: NSValue]()
    // Hold self view dynamic content intrinsicSize
    var combinedContentSize: CGSize = .zero
    
    // for test
    var getInvisibleViews: NSMutableSet {
        return self.invisibleViews
    }
    
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
        return visibilityManager.fillerSpaceManager.hasPadding()
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
    
    func setCustomSpacing(spacing: CGFloat, after view: NSView) {
        stackView.setCustomSpacing(spacing, after: view)
    }
    
    // use this method if a subview to the content stack view needs a padding
    // use configureHeightFor for all cases except when stretching the subview
    // is not desirable.
    
    func addPadding(for view: NSView) -> NSView {
        return visibilityManager.fillerSpaceManager.addPadding(forView: view)
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
        return getViewWithMaxDimension(afterExcluding: view, dimension: { [self] vw in
            var key: String?
            if let vw = vw {
                key = String(format: "%p", vw)
            }
            let value = self.subviewIntrinsicContentSizeCollection[key ?? ""]
            return (value != nil ? value?.sizeValue : .zero)?.height ?? 0.0
        })
    }
    
    func getMaxWidthOfSubviews(afterExcluding view: NSView?) -> CGFloat {
        return getViewWithMaxDimension(afterExcluding: view, dimension: { [self] vw in
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
    
    func register(invisibleView: NSView) {
        self.invisibleViews.add(invisibleView)
    }
    
    /// this method applies visibility to subviews once all of them are rendered and become part of content stack view
    /// applying visibility as each subview is rendered has known side effects.
    /// such as its superview, content stack view becomes hidden if a first subview is set hidden.
    func applyVisibilityToSubviews() {
        for index in 0..<stackView.subviews.count {
            let subview = stackView.subviews[index]
            if !(visibilityManager.fillerSpaceManager.isPadding(subview)) && !(subview is SpacingView) && !(subview is ACRInputLabelTextField) {
                visibilityManager.addVisibleView(index)
            }
        }
        for subview in invisibleViews {
            if let view = subview as? NSView {
                self.hideView(view)
            }
        }
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
        return !hasStretchableView && visibilityManager.hasVisibleViews
    }
    
    func associateSeparator(withOwnerView separator: SpacingView, ownerView: NSView) {
        visibilityManager.fillerSpaceManager.associateSeparator(withOwnerView: separator, ownerView: ownerView)
    }
    
    /// call this method after subview is rendered
    /// it configures height, creates association between the subview and its separator if any
    /// registers subview for its visibility
    func updateLayoutAndVisibilityOfRenderedView(_ renderedView: NSView, acoElement acoElem: ACSBaseCardElement, separator: SpacingView?, rootView: ACRView?) {
        self.configureHeight(for: renderedView, acoElement: acoElem)
        if let separator = separator {
            self.associateSeparator(withOwnerView: separator, ownerView: renderedView)
        }
        // Through the root view visibility context, register renderview with self manager.
        rootView?.visibilityContext?.registerVisibilityManager(self, targetViewIdentifier: renderedView.identifier)
        if !acoElem.getIsVisible() {
            self.register(invisibleView: renderedView)
        }
    }
    
    func configureHeight(for view: NSView?, acoElement element: ACSBaseCardElement?) {
        guard let view = view, let element = element else { return }
        self.visibilityManager.fillerSpaceManager.configureHeight(view: view, correspondingElement: element)
    }
    
    /// call this method once all subviews are rendered
    /// this methods add padding to itself for alignment and stretch
    /// apply visibility to subviews
    /// configure min height
    /// then activate all contraints associated with the configuration.
    /// activation constraint all at once is more efficient than activating
    /// constraints one by one.
    
    func configureLayoutAndVisibility(element: NSObject, isRootMinHeightAvailable: Bool) {
        var minHeight: NSNumber?
        var isBackgroundImageAvailable = false
        if let cardElement = element as? ACSAdaptiveCard {
            self.verticalContentAlignment = cardElement.getVerticalContentAlignment()
            minHeight = cardElement.getMinHeight()
            let bgImage = cardElement.getBackgroundImage()
            if let imageUrl = bgImage?.getUrl(), URL(string: imageUrl) != nil {
                isBackgroundImageAvailable = true
            }
        } else if let collectionElement = element as? ACSCollectionTypeElement {
            self.verticalContentAlignment = collectionElement.getVerticalContentAlignment()
            minHeight = collectionElement.getMinHeight()
            let bgImage = collectionElement.getBackgroundImage()
            if let imageUrl = bgImage?.getUrl(), URL(string: imageUrl) != nil {
                isBackgroundImageAvailable = true
            }
        }
        self.applyVisibilityToSubviews()
        
        if !self.hasStretchableView && !visibilityManager.hasVisibleViews {
            // add stretchable view for stretch the content when stackview has no visibile view
            if self.style != .none || isBackgroundImageAvailable {
                let padding = self.addPadding(for: self)
                self.paddings.append(padding)
                self.addArrangedSubview(padding)
            }
        } else {
            visibilityManager.fillerSpaceManager.addLastStretchableView(for: self, isHidden: (hasStretchableView || !visibilityManager.hasVisibleViews))
        }
        
        self.setMinimumHeight(minHeight)
        visibilityManager.fillerSpaceManager.activateConstraintsForPadding()
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
        guard let view = currentFocussedView as? InputHandlingViewProtocol else {
            logError("currentFocussedView is not InputHandlingView.")
            return
        }
        let errorMessageField = getErrorTextField(for: view)
        errorMessageField?.isHidden = true
    }
    
    func setVerticalHuggingPriority(_ rawValue: Float) {
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue), for: .vertical)
    }
    
    func setMinimumHeight(_ height: NSNumber?) {
        guard let height = height, let heightPt = CGFloat(exactly: height), heightPt > 0 else { return }
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightPt)
        constraint.priority = NSLayoutConstraint.Priority(rawValue: 999)
        constraint.isActive = true
    }
    
    private func hideView(_ viewToBeHidden: NSView) {
        visibilityManager.hide(viewToBeHidden, hostView: self)
        guard let inputView = viewToBeHidden as? InputHandlingViewProtocol else {
            logError("For error visibility checker, field not a input handler :: key.")
            return
        }
        hideErrorMessage(with: inputView)
        setInputLabel(isHidden: true, for: inputView)
    }
    
    private func unhideView(_ viewToBeHidden: NSView) {
        visibilityManager.unhideView(viewToBeHidden, hostView: self)
        guard let inputView = viewToBeHidden as? InputHandlingViewProtocol else {
            logError("For error visibility checker, field not a input handler :: key.")
            return
        }
        if inputView.isErrorShown {
            inputHandlingViewShouldShowError(inputView)
        }
        setInputLabel(isHidden: false, for: inputView)
    }
    
    // MARK: Mouse Events and SelectAction logics
    private var previousBackgroundColor: CGColor?
    override func mouseEntered(with event: NSEvent) {
        guard target != nil else { return }
        previousBackgroundColor = layer?.backgroundColor
        layer?.backgroundColor = ColorUtils.hoverColorOnMouseEnter().cgColor
    }
    
    func configureInputElements(element: ACSBaseInputElement, view: NSView) {
        setupLabel(for: element, view: view)
        addArrangedSubview(view)
        if view is ACRContentStackView {
            view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        setupErrorMessage(element: element, view: view)
    }
    
    func getErrorTextField(for inputView: InputHandlingViewProtocol) -> ACRInputErrorTextField? {
        guard !(self.errorMessageFieldMap.objectEnumerator()?.allObjects.isEmpty ?? true) else {
            logError("For show error message, MapTable is empty.")
            return nil
        }
        guard let errorMessageField = self.errorMessageFieldMap.object(forKey: inputView.key as NSString) else {
            logError("For show error message, field not found in MapTable.")
            return nil
        }
        return errorMessageField
    }
    
    func getLabelTextField(for inputView: InputHandlingViewProtocol) -> ACRInputLabelTextField? {
        guard !(self.inputLabelFieldMap.objectEnumerator()?.allObjects.isEmpty ?? true) else {
            logError("For show label message, MapTable is empty.")
            return nil
        }
        guard let inputLabelField = self.inputLabelFieldMap.object(forKey: inputView.key as NSString) else {
            logError("For input label message, field not found in MapTable.")
            return nil
        }
        return inputLabelField
    }
    
    private func setupLabel(for element: ACSBaseInputElement, view: NSView) {
        guard renderConfig.supportsSchemeV1_3, let label = element.getLabel(), !label.isEmpty, let view = view as? InputHandlingViewProtocol else { return }
        logInfo("setup input label.")
        let labelView = ACRInputLabelTextField(inputElement: element, renderConfig: renderConfig, hostConfig: hostConfig, style: style)
        addArrangedSubview(labelView)
        setCustomSpacing(spacing: 3, after: labelView)
        inputLabelFieldMap.setObject(labelView, forKey: view.key as NSString)
    }
    
    private func setupErrorMessage(element: ACSBaseInputElement, view: NSView) {
        guard renderConfig.supportsSchemeV1_3, let view = view as? InputHandlingViewProtocol, let errorMessage = element.getErrorMessage(), !errorMessage.isEmpty else { return }
        setCustomSpacing(spacing: 5, after: view)
        let errorField = ACRInputErrorTextField(inputElement: element, renderConfig: renderConfig, hostConfig: hostConfig, style: style)
        view.errorDelegate = self
        addArrangedSubview(errorField)
        errorMessageFieldMap.setObject(errorField, forKey: view.key as NSString)
    }
    
    private func setInputLabel(isHidden hidden: Bool, for view: InputHandlingViewProtocol) {
        let inputLabelField = self.getLabelTextField(for: view)
        inputLabelField?.isHidden = hidden
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
        let errorMessageField = self.getErrorTextField(for: view)
        if !view.isHidden {
            errorMessageField?.isHidden = false
        }
    }
    
    func inputHandlingViewShouldHideError(_ view: InputHandlingViewProtocol, currentFocussedView: NSView?) {
        hideErrorMessage(with: view)
    }
    
    func inputHandlingViewShouldAnnounceErrorMessage(_ view: InputHandlingViewProtocol, message: String?) {
        let errorMessagePrefixString = renderConfig.localisedStringConfig.errorMessagePrefixString + ", "
        var errorMessageString = ""
        var labelString = ""
        if let errorMessageField = self.getErrorTextField(for: view) {
            if !view.isHidden {
                errorMessageString = errorMessageField.stringValue + ". "
            }
        }
        if let inputLabelField = self.getLabelTextField(for: view) {
            if !view.isHidden {
                labelString = inputLabelField.stringValue + ". "
            }
        }
        let announcementString = message ?? (errorMessagePrefixString + errorMessageString + labelString)
        NSAccessibility.announce(announcementString)
    }
    
    func isErrorVisible(_ view: InputHandlingViewProtocol) -> Bool {
        guard let errorMessageField = self.getErrorTextField(for: view) else {
            return true
        }
        return !errorMessageField.isHidden
    }
}

extension ACRContentStackView: ACSVisibilityManagerFacade {
    func visibilityManager(hideView view: NSView) {
        self.hideView(view)
    }
    
    func visibilityManager(unhideView view: NSView) {
        self.unhideView(view)
    }
    
    func visibilityManagerAllStretchableViewsHidden() -> Bool {
        return !visibilityManager.fillerSpaceManager.hasPadding()
    }
    
    func visibilityManagerSetLastStretchableView(isHidden: Bool) {
        visibilityManager.changeVisibilityOfLastStretchableView(isHidden: isHidden)
    }
    
    func visibilityManagerReactivateConstraint() {
        visibilityManager.fillerSpaceManager.deactivateConstraintsForPadding()
        visibilityManager.fillerSpaceManager.activateConstraintsForPadding()
    }
}

class NoClippingLayer: CALayer {
    override var masksToBounds: Bool {
        get { return false }
        set { }
    }
}
