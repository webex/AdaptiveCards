import AdaptiveCards_bridge
import AppKit

class TextInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = TextInputRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let inputBlock = element as? ACSTextInput else {
            logError("Element is not of type ACSTextInput")
            return NSView()
        }
        let stackview: NSStackView = {
            let view = NSStackView()
            view.orientation = .horizontal
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        let action = inputBlock.getInlineAction()
        var renderButton = false
        switch action {
        case is ACSOpenUrlAction:
            renderButton = true
        case is ACSToggleVisibilityAction:
            renderButton = true
        case is ACSSubmitAction:
            renderButton = true
        default:
            renderButton = false
        }
        
        if inputBlock.getIsMultiline() {
            let multilineView = ACRMultilineInputTextView(config: config, inputElement: inputBlock)
            multilineView.setId(inputBlock.getId())
            multilineView.setVisibilty(to: inputBlock.getIsVisible())
            if let placeholderString = inputBlock.getPlaceholder() {
                multilineView.setPlaceholder(placeholderString)
            }
            if let valueString = inputBlock.getValue(), !valueString.isEmpty {
                multilineView.setValue(value: valueString, maximumLen: inputBlock.getMaxLength())
            }
            multilineView.maxLen = inputBlock.getMaxLength() as? Int ?? 0
            multilineView.regex = inputBlock.getRegex()
            multilineView.isRequired = inputBlock.getIsRequired()
            // Add Input Handler
            
            rootView.addInputHandler(multilineView)
            if renderButton {
                stackview.addArrangedSubview(multilineView)
                addInlineButton(parentview: stackview, view: multilineView, element: inputBlock, style: style, with: hostConfig, rootview: rootView, config: config)
                return stackview
            }
            return multilineView
        } else {
            let inputTextView = ACRSingleLineInputTextView(renderConfig: config, element: inputBlock, style: style, with: hostConfig, rootview: rootView)
            return inputTextView
        }
    }
    
    private func addInlineButton(parentview: NSStackView, view: NSView, element: ACSTextInput, style: ACSContainerStyle, with hostConfig: ACSHostConfig, rootview: ACRView, config: RenderConfig) {
        guard let action = element.getInlineAction() else {
            return logError("InlineAction is nil")
        }
        let button = ACRButton(actionElement: action, iconPlacement: hostConfig.getActions()?.iconPlacement, buttonConfig: config.buttonConfig, style: .inline)
        if let iconUrl = action.getIconUrl(), !iconUrl.isEmpty {
            rootview.registerImageHandlingView(button, for: iconUrl)
        }

        let attributedString: NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: button.title)
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        parentview.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if view is ACRMultilineInputTextView {
            button.setContentHuggingPriority(.required, for: .vertical)
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        button.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5).isActive = true
        button.attributedTitle = attributedString
        
        // adding target to the Buttons
        switch action.getType() {
        case .openUrl:
            guard let openURLAction = action as? ACSOpenUrlAction else {
                logError("Element is not of type ACSOpenUrlAction")
                return
            }
            let target = ActionOpenURLTarget(element: openURLAction, delegate: rootview)
            target.configureAction(for: button)
            rootview.addTarget(target)
        case .submit:
            guard let submitAction = action as? ACSSubmitAction else {
                logError("Element is not of type ACSSubmitAction")
                return
            }
            let target = ActionSubmitTarget(element: submitAction, delegate: rootview)
            target.configureAction(for: button)
            rootview.addTarget(target)
        default:
            break
        }
    }
}
