import AdaptiveCards_bridge
import AppKit

protocol BaseInputHandler { }

protocol BaseCardElementRendererProtocol {
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView
}

protocol BaseActionElementRendererProtocol {
    func render(action: ACSBaseActionElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, targetHandlerDelegate: TargetHandlerDelegate, inputs: [BaseInputHandler], config: RenderConfig) -> NSView
}

protocol TargetHandler: NSObject {
    var delegate: TargetHandlerDelegate? { get }
    func configureAction(for button: NSButton)
    func handleSelectionAction(for actionView: NSView)
}

protocol TargetHandlerDelegate: AnyObject {
    func handleOpenURLAction(actionView: NSView, urlString: String)
    func handleSubmitAction(actionView: NSView, dataJson: String?, associatedInputs: Bool)
    func handleToggleVisibilityAction(actionView: NSView, toggleTargets: [ACSToggleVisibilityTarget])
}

protocol ShowCardTargetHandlerDelegate: TargetHandlerDelegate {
    func handleShowCardAction(button: NSButton, showCard: ACSAdaptiveCard)
}

protocol InputHandlingViewProtocol: NSView {
    var value: String { get }
    var key: String { get }
    var isValid: Bool { get }
    var isRequired: Bool { get }
    var errorDelegate: InputHandlingViewErrorDelegate? { get set }
    func showError()
    func setAccessibilityFocus()
}

protocol InputHandlingViewErrorDelegate: AnyObject {
    func inputHandlingViewShouldShowError(_ view: InputHandlingViewProtocol)
    func inputHandlingViewShouldHideError(_ view: InputHandlingViewProtocol, currentFocussedView: NSView?)
    func inputHandlingViewShouldAnnounceErrorMessage(_ view: InputHandlingViewProtocol, message: String?)
    var isErrorVisible: Bool { get }
}

protocol ShowCardHandlingView: NSView {
    typealias ShowCardItems = (id: NSNumber, button: NSButton, showCard: NSView)
    var showCardsMap: [NSNumber: NSView] { get }
    var currentShowCardItems: ShowCardItems? { get }
}

extension InputHandlingViewProtocol {
    var isBasicValidationsSatisfied: Bool {
        guard isRequired else { return true }
        return !value.isEmpty
    }
}
