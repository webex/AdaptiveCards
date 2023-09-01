import AdaptiveCards_bridge
import AppKit

class ActionSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ActionSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let actionSet = element as? ACSActionSet else {
            logError("Element is not of type ACSActionSet")
            return NSView()
        }
        return renderView(actions: actionSet.getActions(), aligned: actionSet.getHorizontalAlignment(), with: hostConfig, style: style, rootView: rootView, parentView: parentView, inputs: inputs, config: config, actionElement: element)
    }
    
    func renderActionButtons(actions: [ACSBaseActionElement], with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        // This renders Action in AdaptiveCards if it has horizontal orientation,
        // vertical card are always stretched to fill full width
        let actionHorizontalAlignment: ACSHorizontalAlignment
        switch hostConfig.getActions()?.actionAlignment {
        case .left: actionHorizontalAlignment = .left
        case .center: actionHorizontalAlignment = .center
        case .right: actionHorizontalAlignment = .right
        default: actionHorizontalAlignment = .left
        }
        return renderView(actions: actions, aligned: actionHorizontalAlignment, with: hostConfig, style: style, rootView: rootView, parentView: parentView, inputs: inputs, config: config)
    }
    
    private func renderView(actions: [ACSBaseActionElement], aligned horizontalAlignment: ACSHorizontalAlignment, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig, actionElement: ACSBaseCardElement? = nil) -> NSView {
        let actionsConfig = hostConfig.getActions()
        let actionsOrientation = actionsConfig?.actionsOrientation ?? .vertical
        let actionsButtonSpacing = actionsConfig?.buttonSpacing ?? 8
        let exteriorPadding = hostConfig.getSpacing()?.paddingSpacing ?? 0
        let maxAllowedActions = Int(truncating: actionsConfig?.maxActions ?? 10)
        
        if actions.count > maxAllowedActions {
            logError("WARNING: Some actions were not rendered due to exceeding the maximum number \(maxAllowedActions) actions are allowed")
        }
        
        let orientation: NSUserInterfaceLayoutOrientation
        switch actionsOrientation {
        case .horizontal: orientation = .horizontal
        case .vertical: orientation = .vertical
        @unknown default: orientation = .vertical
        }
        
        let resolvedHorizontalAlignment: NSLayoutConstraint.Attribute
        switch horizontalAlignment {
        case .center: resolvedHorizontalAlignment = orientation == .horizontal ? .centerY : .centerX
        case .left: resolvedHorizontalAlignment = .leading
        case .right: resolvedHorizontalAlignment = .trailing
        @unknown default: resolvedHorizontalAlignment = .leading
        }
        
        let actionSetView = ACRActionSetView(orientation: orientation, alignment: resolvedHorizontalAlignment, buttonSpacing: CGFloat(exactly: actionsButtonSpacing) ?? 8, exteriorPadding: CGFloat(exactly: exteriorPadding) ?? 0)
        
        let resolvedCount = min(actions.count, maxAllowedActions)
        let filteredActions = actions[0 ..< resolvedCount]
        let actionViews: [NSView] = filteredActions.map {
            let renderer = RendererManager.shared.actionRenderer(for: $0.getType())
            return renderer.render(action: $0, with: hostConfig, style: style, rootView: rootView, parentView: rootView, targetHandlerDelegate: actionSetView, inputs: [], config: config)
        }
        
        guard !filteredActions.isEmpty else {
            logError("Actions is empty")
            return NSView()
        }
        
        actionSetView.setActions(actionViews)
        actionSetView.delegate = rootView
        
        if let actionElement = actionElement {
            if actionElement.getHeight() == .stretch {
                actionSetView.setStretchableHeight()
            }
        }
        
        return actionSetView
    }
}
