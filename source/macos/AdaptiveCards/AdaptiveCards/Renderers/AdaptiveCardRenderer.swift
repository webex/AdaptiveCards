import AdaptiveCards_bridge
import AppKit

class AdaptiveCardRenderer {
    static let shared = AdaptiveCardRenderer()
    
    func renderAdaptiveCard(_ card: ACSAdaptiveCard, with hostConfig: ACSHostConfig, width: CGFloat, config: RenderConfig, actionDelegate: AdaptiveCardActionDelegate?, resourceResolver: AdaptiveCardResourceResolver?) -> NSView {
        var style: ACSContainerStyle = .default
        if let colorConfig = hostConfig.getAdaptiveCard() {
            style = (colorConfig.allowCustomStyle && card.getStyle() != .none) ? card.getStyle() : .default
        }
        let cardView = renderAdaptiveCard(card, with: hostConfig, style: style, width: width, config: config, actionDelegate: actionDelegate, resourceResolver: resourceResolver)
        cardView.layoutSubtreeIfNeeded()
        return cardView
    }
    
    func renderShowCard(_ card: ACSAdaptiveCard, with hostConfig: ACSHostConfig, parent: ACRView, config: RenderConfig) -> NSView {
        var style: ACSContainerStyle = .default
        if let colorConfig = hostConfig.getAdaptiveCard() {
            let showCardStyle = hostConfig.getActions()?.showCard.style ?? .default
            style = colorConfig.allowCustomStyle ? card.getStyle() : showCardStyle
        }
        guard let cardView = renderAdaptiveCard(card, with: hostConfig, style: style, config: config, actionDelegate: parent.delegate, resourceResolver: parent.resolverDelegate, parentRootView: parent) as? ACRView else {
            logError("renderAdaptiveCard should return ACRView")
            return NSView()
        }
        cardView.parent = parent
        return cardView
    }
    
    private func renderAdaptiveCard(_ card: ACSAdaptiveCard, with hostConfig: ACSHostConfig, style: ACSContainerStyle, width: CGFloat? = nil, config: RenderConfig, actionDelegate: AdaptiveCardActionDelegate?, resourceResolver: AdaptiveCardResourceResolver?, parentRootView: ACRView? = nil) -> NSView {
        var visibilityContext: ACOVisibilityContext?
        var accessibilityContext: ACSAccessibilityFocusManager?
        if parentRootView?.visibilityContext != nil {
            // This block invokes by the showcard function. We've passed the same visibility context to the current root view, so we can change visibility any element within the entire card.
            visibilityContext = parentRootView?.visibilityContext
            accessibilityContext = parentRootView?.accessibilityContext
        } else {
            visibilityContext = ACOVisibilityContext()
            accessibilityContext = ACSAccessibilityFocusManager()
        }
        let rootView = ACRView(style: style, hostConfig: hostConfig, renderConfig: config, visibilityContext: visibilityContext, accessibilityContext: accessibilityContext)
        rootView.accessibilityContext?.registerView(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            rootView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        rootView.delegate = actionDelegate
        rootView.resolverDelegate = resourceResolver
        rootView.setMinimumHeight(card.getMinHeight())
        if card.getVersion() == "1.3", !config.supportsSchemeV1_3 {
            logError("CardVersion 1.3 not supported, Card properties of this version and above won't be rendered")
        }
        for (index, element) in card.getBody().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: element.getType())
            let view = renderer.render(element: element, with: hostConfig, style: style, rootView: rootView, parentView: rootView, inputs: [], config: config)
            BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: element, parentView: rootView, rootView: rootView, style: style, hostConfig: hostConfig, config: config, isfirstElement: isFirstElement)
            BaseCardElementRenderer.shared.configBleed(collectionView: view, parentView: rootView, with: hostConfig, element: element, parentElement: nil)
        }
        
        if !card.getActions().isEmpty {
            let view = ActionSetRenderer.shared.renderActionButtons(actions: card.getActions(), with: hostConfig, style: style, rootView: rootView, parentView: rootView, inputs: [], config: config)
            // getting spacing from hostConfig
            if let verticalSpacing = hostConfig.getActions()?.spacing {
                let spacing = HostConfigUtils.getSpacing(verticalSpacing, with: hostConfig)
                // add vertical spacing b/w action button view and last BaseCard Element
                if let lastView = rootView.arrangedSubviews.last(where: { !$0.isHidden }) {
                    rootView.setCustomSpacing(spacing: CGFloat(truncating: spacing), after: lastView)
                }
            }
            rootView.addArrangedSubview(view)
        }
        
        // add selectAction
        rootView.setupSelectAction(card.getSelectAction(), rootView: rootView)
        rootView.setupSelectActionAccessibility(on: rootView, for: card.getSelectAction())
        
        if let backgroundImage = card.getBackgroundImage(), let url = backgroundImage.getUrl() {
            rootView.setupBackgroundImageProperties(backgroundImage)
            rootView.registerImageHandlingView(rootView.backgroundImageView, for: url)
        }
        
        rootView.configureLayoutAndVisibility(verticalContentAlignment: card.getVerticalContentAlignment(), minHeight: card.getMinHeight())
        rootView.appearance = NSAppearance.getAppearance(isDark: config.isDarkMode)
        rootView.dispatchImageResolveRequests()
        return rootView
    }
}

extension NSAppearance {
    static func getAppearance(isDark: Bool) -> NSAppearance? {
        guard isDark else { return NSAppearance(named: .aqua) }
        if #available(macOS 10.14, *) {
            return NSAppearance(named: .darkAqua)
        } else {
            return NSAppearance(named: .vibrantDark)
        }
    }
}
