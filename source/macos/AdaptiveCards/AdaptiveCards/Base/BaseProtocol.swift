import AdaptiveCards_bridge
import AppKit

protocol BaseInputHandler { }

protocol BaseCardElementRendererProtocol {
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView
}

protocol BaseActionElementRendererProtocol {
    func render(action: ACSBaseActionElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView
}

protocol TargetHandler: NSObject {
    var delegate: TargetHandlerDelegate? { get set }
    func configureAction(for button: NSButton)
    func handleSelectionAction(for actionView: NSView)
}

protocol TargetHandlerDelegate: AnyObject {
    func handleOpenURLAction(actionView: NSView, urlString: String)
    func handleSubmitAction(actionView: NSView, dataJson: String?)
    func handleShowCardAction(button: NSButton, showCard: ACSAdaptiveCard)
}

protocol InputHandlingViewProtocol: NSView {
    var value: String { get }
    var key: String { get }
    var isValid: Bool { get }
}

protocol SelectActionHandlingProtocol {
    func setupSelectAction(selectAction: ACSBaseActionElement?, rootView: NSView) -> TargetHandler?
}

extension SelectActionHandlingProtocol {
    func setupSelectAction(selectAction: ACSBaseActionElement?, rootView: NSView) -> TargetHandler? {
        guard let selectAction = selectAction, let rootView = rootView as? ACRView else { return nil }
        var target: TargetHandler?
        switch selectAction.getType() {
        case .openUrl:
            guard let openURLAction = selectAction as? ACSOpenUrlAction else { break }
            target = ActionOpenURLTarget(element: openURLAction, delegate: rootView)
            
        case .submit:
            guard let submitAction = selectAction as? ACSSubmitAction else { break }
            target = ActionSubmitTarget(element: submitAction, delegate: rootView)
            
        default:
            break
        }
        
        if let actionTarget = target {
            rootView.addTarget(actionTarget)
        }
        return target
    }
}
