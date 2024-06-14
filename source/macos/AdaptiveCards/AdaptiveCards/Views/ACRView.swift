import AdaptiveCards_bridge
import AppKit

class ACRView: ACRColumnView {
    weak var delegate: AdaptiveCardActionDelegate?
    weak var resolverDelegate: AdaptiveCardResourceResolver?
    weak var parent: ACRView?

    private (set) var targets: [TargetHandler] = []
    private (set) var inputHandlers: [InputHandlingViewProtocol] = []
    private (set) var imageViewMap: [String: [ImageHoldingView]] = [:]
    private (set) var renderedShowCards: [NSView] = []
    private (set) var initialLayoutDone = false
    private var refocusedActionElementView: NSView?
    private var needsLayoutRefocus = false
    private var focusedElementOnHideError: NSView?
    private var firstFieldWithError: InputHandlingViewProtocol?
    private (set) var visibilityContext: ACOVisibilityContext?
    private (set) var accessibilityContext: ACSAccessibilityFocusManager?
    private (set) var cardWidth: CGFloat?
    let queryManager = QueryManager()
    
    // AccessibleFocusView property
    override var validKeyView: NSView? {
        get {
            return self
        }
        set { }
    }
    
    override init(style: ACSContainerStyle, hostConfig: ACSHostConfig, renderConfig: RenderConfig) {
        super.init(style: style, parentStyle: nil, hostConfig: hostConfig, renderConfig: renderConfig, superview: nil, needsPadding: true)
        queryManager.delegate = self
    }
    
    convenience init(style: ACSContainerStyle, hostConfig: ACSHostConfig, renderConfig: RenderConfig, visibilityContext: ACOVisibilityContext?, accessibilityContext: ACSAccessibilityFocusManager?) {
        self.init(style: style, hostConfig: hostConfig, renderConfig: renderConfig)
        self.visibilityContext = visibilityContext
        self.accessibilityContext = accessibilityContext
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var previousBounds: NSRect?
    private var boundsBeforeShowCard: NSRect?
    override func layout() {
        super.layout()
        guard window != nil else { return }
        if let pBounds = previousBounds, bounds.height != pBounds.height {
            delegate?.adaptiveCard(self, didUpdateBoundsFrom: pBounds, to: bounds)
            initialLayoutDone = true
            parent?.resetKeyboardFocus()
            resetKeyboardFocus()
        }
        previousBounds = bounds
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        needsLayoutRefocus = false
        focusedElementOnHideError = nil
        firstFieldWithError = nil
    }
    
    // AccessibleFocusView property
    override func setupInternalKeyviews() {
        self.nextKeyView = exitView?.validKeyView
    }
    
    func addTarget(_ target: TargetHandler) {
        targets.append(target)
    }
    
    func addInputHandler(_ handler: InputHandlingViewProtocol) {
        inputHandlers.append(handler)
    }
    
    func resolveAttributedString(for htmlString: String) -> NSAttributedString? {
        return resolverDelegate?.adaptiveCard(self, attributedStringFor: htmlString)
    }
    
    func registerImageHandlingView(_ view: ImageHoldingView, for url: String) {
        if imageViewMap[url] == nil {
            imageViewMap[url] = []
        }
        imageViewMap[url]?.append(view)
    }
    
    func getImageDimensions(for url: String) -> NSSize? {
        return resolverDelegate?.adaptiveCard(self, dimensionsForImageWith: url)
    }
    
    func setCardWidth(_ value: CGFloat?) {
        self.cardWidth = value
    }
    
    func resetKeyboardFocus() {
        if needsLayoutRefocus, let focusedView = refocusedActionElementView {
            focusedView.setAccessibilityFocused(true)
        } else if focusedElementOnHideError != nil {
            focusedElementOnHideError?.setAccessibilityFocused(true)
            // If it is a textfield, the entered text gets selected when focus is set, so taking the cursor to the last position it was present
            guard let focusedTextField = focusedElementOnHideError as? ACRTextField else { return }
            focusedTextField.resetCursorPositionIfNeeded()
        } else if firstFieldWithError != nil {
            firstFieldWithError?.setAccessibilityFocus()
        }
    }
    
    override func hideErrorMessage(with currentFocussedView: NSView?) {
        super.hideErrorMessage(with: currentFocussedView)
        focusedElementOnHideError = currentFocussedView
    }
    
    private func submitCardInputs(actionView: NSView, dataJSON: String?, associatedInputs: Bool) {
        var dict = [String: Any]()
        
        if let data = dataJSON?.data(using: String.Encoding.utf8), let dataJsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            dict = dataJsonDict
        // data != "null\n" check is required as the objective String does not return nil if no data present
        } else if let data = dataJSON, data != "null\n" {
            let jsonStr = "{\"data\" : \(data)}"
            if let data = jsonStr.data(using: String.Encoding.utf8), let jsonDataObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                dict = jsonDataObj
            } else {
                dict["data"] = data
            }
        }
        
        // recursively fetch input handlers dictionary from the parent
        var rootView = self
        var parentView: ACRView? = self
        var canSubmit = true
        let shouldSubmitUserInput = !renderConfig.supportsSchemeV1_3 || (renderConfig.supportsSchemeV1_3 && associatedInputs)
        guard shouldSubmitUserInput else {
            delegate?.adaptiveCard(rootView, didSubmitUserResponses: dict, actionView: actionView)
            return
        }
        repeat {
            if let handlers = parentView?.inputHandlers {
                var isFirstErrorFieldInView = true
                for handler in handlers {
                    guard !renderConfig.supportsSchemeV1_3 || handler.isValid else {
                        handler.showError()
                        if isFirstErrorFieldInView && !handler.isHidden {
                            firstFieldWithError = handler
                            resetKeyboardFocus()
                            isFirstErrorFieldInView = false
                        }
                        canSubmit = false
                        continue
                    }
                    dict[handler.key] = handler.value
                }
            }
            if let curr = parentView, curr.parent == nil {
                rootView = curr
            }
            parentView = parentView?.parent
        } while parentView != nil
        
        guard canSubmit else { return }
        delegate?.adaptiveCard(rootView, didSubmitUserResponses: dict, actionView: actionView)
    }
    
    private func toggleVisibity(of targets: [ACSToggleVisibilityTarget]) {
        queryManager.handleQueryResponse(resolverDelegate: resolverDelegate)
        var facadeArray: [ACSVisibilityManagerFacade?] = []
        for target in targets {
            guard let id = target.getElementId(), let toggleView = self.findView(withIdentifier: id) else {
                logError("Target with ID '\(target.getElementId() ?? "nil")' not found for toggleVisibility.")
                continue
            }
            let facade = visibilityContext?.retrieveVisiblityManager(withIdentifier: toggleView.identifier)
            var isHide = false
            switch target.getIsVisible() {
            case .isVisibleToggle:
                isHide = !toggleView.isHidden
            case .isVisibleTrue:
                isHide = false
            case .isVisibleFalse:
                isHide = true
            @unknown default:
                logError("Unknown ToggleIsVisible value \(target.getIsVisible())")
            }
            if let facade = facade {
                if isHide {
                    facade.visibilityManager(hideView: toggleView)
                } else {
                    facade.visibilityManager(unhideView: toggleView)
                }
            }
            
            // toggle the last padding if all other
            facade?.visibilityManagerSetLastStretchableView(isHidden: !(facade?.visibilityManagerAllStretchableViewsHidden() ?? false))
            facadeArray.append(facade)
        }
        
        for facade in facadeArray {
            facade?.visibilityManagerUpdateConstraint()
        }
        facadeArray.removeAll()
        self.accessibilityContext?.recalculateKeyViewLoop()
    }
    
    private func sendActionEvent(action: CardActionEvent, from sourceView: NSView) {
        var source: CardActionSource = .button
        if sourceView is ACRView {
            source = .adaptivecard
        } else if sourceView is ACRContainerView {
            source = .container
        } else if sourceView is ACRColumnSetView {
            source = .columnset
        } else if sourceView is ACRColumnView {
            source = .column
        } else if sourceView is ACRImageWrappingView {
            source = .image
        } else if sourceView is ACRButton {
            source = .button
        } else if sourceView is ACRActionSetView {
            source = .button
        } else if sourceView is ACRTextView {
            source = .text
        }
        delegate?.adaptiveCard(self, didActionWith: action, from: source)
    }
}

extension ACRView: ACRActionSetViewDelegate {
    func actionSetView(_ view: ACRActionSetView, didOpenURL urlString: String, with actionView: NSView) {
        delegate?.adaptiveCard(self, didSelectOpenURL: urlString)
        sendActionEvent(action: .openurl, from: actionView)
    }
    
    func actionSetView(_ view: ACRActionSetView, didSubmitInputsWith actionView: NSView, dataJson: String?, associatedInputs: Bool) {
        submitCardInputs(actionView: actionView, dataJSON: dataJson, associatedInputs: associatedInputs)
        sendActionEvent(action: .submit, from: actionView)
    }
    
    func actionSetView(_ view: ACRActionSetView, didToggleVisibilityActionWith actionView: NSView, toggleTargets: [ACSToggleVisibilityTarget]) {
        refocusedActionElementView = actionView
        needsLayoutRefocus = true
        toggleVisibity(of: toggleTargets)
        sendActionEvent(action: .toggle, from: actionView)
    }
    
    func actionSetView(_ view: ACRActionSetView, willShowCardWith button: NSButton) {
        self.accessibilityContext?.setPointerHead(to: button)
        boundsBeforeShowCard = bounds
        if let buttonCell = button.cell, buttonCell.isAccessibilityFocused() {
            refocusedActionElementView = buttonCell.controlView
            needsLayoutRefocus = true
        }
        sendActionEvent(action: .showcard, from: button)
    }
    
    func actionSetView(_ view: ACRActionSetView, didShowCardWith button: NSButton) {
        self.accessibilityContext?.setPointerHeadToLast()
        delegate?.adaptiveCard(self, didShowCardWith: button, previousHeight: boundsBeforeShowCard?.height ?? -1, newHeight: bounds.height)
        self.accessibilityContext?.recalculateKeyViewLoop()
    }
    
    func actionSetView(_ view: ACRActionSetView, renderShowCardFor cardData: ACSAdaptiveCard) -> NSView {
        let cardView = AdaptiveCardRenderer.shared.renderShowCard(cardData, with: hostConfig, parent: self, config: renderConfig)
        renderedShowCards.append(cardView)
        return cardView
    }
}

extension ACRView: TargetHandlerDelegate {
    func handleToggleVisibilityAction(actionView: NSView, toggleTargets: [ACSToggleVisibilityTarget]) {
        refocusedActionElementView = actionView
        needsLayoutRefocus = true
        toggleVisibity(of: toggleTargets)
        sendActionEvent(action: .toggle, from: actionView)
    }
    
    func handleOpenURLAction(urlString: String, actionView: NSView) {
        delegate?.adaptiveCard(self, didSelectOpenURL: urlString)
        sendActionEvent(action: .openurl, from: actionView)
    }
    
    func handleSubmitAction(actionView: NSView, dataJson: String?, associatedInputs: Bool) {
        submitCardInputs(actionView: actionView, dataJSON: dataJson, associatedInputs: associatedInputs)
        sendActionEvent(action: .submit, from: actionView)
    }
}

extension ACRView: ImageResourceHandlerView {
    func setImage(_ image: NSImage, for url: String) {
        guard let imageViews = imageViewMap[url] else {
            logError("No views registered for url '\(url)'")
            return
        }
        DispatchQueue.main.async {
            for imageView in imageViews {
                imageView.setImage(image)
            }
        }
    }
    
    func setImage(_ image: NSImage, forURLsContaining matcher: @escaping (String) -> Bool) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.imageViewMap.keys
                .filter { matcher($0) }
                .forEach { self.setImage(image, for: $0) }
            
            self.renderedShowCards
                .compactMap { $0 as? ImageResourceHandlerView }
                .forEach { $0.setImage(image, forURLsContaining: matcher) }
        }
    }
    
    func dispatchImageResolveRequests() {
        for url in imageViewMap.keys {
            resolverDelegate?.adaptiveCard(self, requestImageFor: url)
        }
    }
}

extension ACRView: QueryResponseDelegate {
    func didReceiveQueryResponse(_ response: QueryResponse?) {
        // Handle the successful response
        print("Received Query Response:", response ?? "lol")
        // Do something with the response here
    }

    func didFailWithError(_ error: Error) {
        // Handle the error
        guard let error = error as? TypeAheadParsingError else {
            print("Failed with error:", error.localizedDescription)
            return
        }
        print("Decoding error with details: \(error.kind), \(error.description), \(error.path)")
        // Show an error message or take other appropriate action
    }
}
