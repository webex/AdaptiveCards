import AdaptiveCards_bridge
import AppKit

protocol SelectActionHandlingProtocol: AnyObject {
    var target: TargetHandler? { get set }
    func getTargetHandler(for selectAction: ACSBaseActionElement?, rootView: ACRView) -> TargetHandler?
    func setupSelectAction(_ selectAction: ACSBaseActionElement?, rootView: ACRView)
}

extension SelectActionHandlingProtocol {
    func getTargetHandler(for selectAction: ACSBaseActionElement?, rootView: ACRView) -> TargetHandler? {
        guard let selectAction = selectAction else { return nil }
        var target: TargetHandler?
        switch selectAction.getType() {
        case .openUrl:
            guard let openURLAction = selectAction as? ACSOpenUrlAction else { break }
            target = ActionOpenURLTarget(element: openURLAction, delegate: rootView)
            
        case .submit:
            guard let submitAction = selectAction as? ACSSubmitAction else { break }
            target = ActionSubmitTarget(element: submitAction, delegate: rootView)
            
        case .toggleVisibility:
            guard let toggleAction = selectAction as? ACSToggleVisibilityAction else { break }
            target = ActionToggleVisibilityTarget(toggleTargets: toggleAction.getTargetElements(), delegate: rootView)
            
        default:
            break
        }
        return target
    }
    
    func setupSelectAction(_ selectAction: ACSBaseActionElement?, rootView: ACRView) {
        guard let actionTarget = getTargetHandler(for: selectAction, rootView: rootView) else { return }
        target = actionTarget
        rootView.addTarget(actionTarget)
    }
}
