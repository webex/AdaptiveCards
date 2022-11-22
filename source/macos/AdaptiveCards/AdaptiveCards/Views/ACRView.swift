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
    private (set) var isMinHeightAvailable = false
    private var currentFocusedActionElement: NSCell?
    private var isLayoutDoneOnShowCard = false
    private var focusedElementOnHideError: NSView?
    private var firstFieldWithError: InputHandlingViewProtocol?
    private (set) var visibilityContext: ACOVisibilityContext?
    
    override init(style: ACSContainerStyle, hostConfig: ACSHostConfig, renderConfig: RenderConfig) {
        super.init(style: style, parentStyle: nil, hostConfig: hostConfig, renderConfig: renderConfig, superview: nil, needsPadding: true)
    }
    
    convenience init(style: ACSContainerStyle, hostConfig: ACSHostConfig, renderConfig: RenderConfig, visibilityContext: ACOVisibilityContext?) {
        self.init(style: style, hostConfig: hostConfig, renderConfig: renderConfig)
        self.visibilityContext = visibilityContext
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
        isLayoutDoneOnShowCard = false
        focusedElementOnHideError = nil
        firstFieldWithError = nil
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
    
    func dispatchResolveRequests() {
        for url in imageViewMap.keys {
            resolverDelegate?.adaptiveCard(self, requestImageFor: url)
        }
    }
    
    func resetKeyboardFocus() {
        if isLayoutDoneOnShowCard, let lastFocusedElement = currentFocusedActionElement {
            lastFocusedElement.controlView?.setAccessibilityFocused(true)
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
    
    override func setMinimumHeight(_ height: NSNumber?) {
        super.setMinimumHeight(height)
        if let height = height?.intValue, height > 0 {
            isMinHeightAvailable = true
        }
    }
    
    private func submitCardInputs(actionView: NSView, dataJSON: String?, associatedInputs: Bool) {
        var dict = [String: Any]()
        
        if let data = dataJSON?.data(using: String.Encoding.utf8), let dataJsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            dict = dataJsonDict
        // data != "null\n" check is required as the objective String does not return nil if no data present
        } else if let data = dataJSON, data != "null\n" {
            dict["data"] = data
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
                        if isFirstErrorFieldInView {
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
            if facade?.visibilityManagerAllStretchableViewsHidden() ?? false {
                facade?.visibilityManagerSetLastStretchableView(isHidden: !isHide)
            } else {
                facade?.visibilityManagerSetLastStretchableView(isHidden: isHide)
            }
        }
    }
}

extension ACRView: ACRActionSetViewDelegate {
    func actionSetView(_ view: ACRActionSetView, didOpenURLWith actionView: NSView, urlString: String) {
        delegate?.adaptiveCard(self, didSelectOpenURL: urlString, actionView: actionView)
    }
    
    func actionSetView(_ view: ACRActionSetView, didSubmitInputsWith actionView: NSView, dataJson: String?, associatedInputs: Bool) {
        submitCardInputs(actionView: actionView, dataJSON: dataJson, associatedInputs: associatedInputs)
    }
    
    func actionSetView(_ view: ACRActionSetView, didToggleVisibilityActionWith actionView: NSView, toggleTargets: [ACSToggleVisibilityTarget]) {
        toggleVisibity(of: toggleTargets)
    }
    
    func actionSetView(_ view: ACRActionSetView, willShowCardWith button: NSButton) {
        boundsBeforeShowCard = bounds
        if let buttonCell = button.cell, buttonCell.isAccessibilityFocused() {
            currentFocusedActionElement = buttonCell
            isLayoutDoneOnShowCard = true
        }
    }
    
    func actionSetView(_ view: ACRActionSetView, didShowCardWith button: NSButton) {
        delegate?.adaptiveCard(self, didShowCardWith: button, previousHeight: boundsBeforeShowCard?.height ?? -1, newHeight: bounds.height)
    }
    
    func actionSetView(_ view: ACRActionSetView, renderShowCardFor cardData: ACSAdaptiveCard) -> NSView {
        let cardView = AdaptiveCardRenderer.shared.renderShowCard(cardData, with: hostConfig, parent: self, config: renderConfig)
        renderedShowCards.append(cardView)
        return cardView
    }
}

extension ACRView: TargetHandlerDelegate {
    func handleToggleVisibilityAction(actionView: NSView, toggleTargets: [ACSToggleVisibilityTarget]) {
        toggleVisibity(of: toggleTargets)
    }
    
    func handleOpenURLAction(actionView: NSView, urlString: String) {
        delegate?.adaptiveCard(self, didSelectOpenURL: urlString, actionView: actionView)
    }
    
    func handleSubmitAction(actionView: NSView, dataJson: String?, associatedInputs: Bool) {
        submitCardInputs(actionView: actionView, dataJSON: dataJson, associatedInputs: associatedInputs)
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
}
