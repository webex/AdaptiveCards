import AdaptiveCards_bridge
import AppKit

protocol ACRViewDelegate: AnyObject {
    func acrView(_ view: ACRView, didSelectOpenURL url: String, button: NSButton)
    func acrInputViewHandler(_ view: ACRView, didSubmitUserResponses: [String: String], button: NSButton )
}

class ACRView: ACRColumnView {
    weak var delegate: ACRViewDelegate?
    private (set) var targets: [TargetHandler] = []
    private (set) var inputHandlers: [InputHandlingViewProtocol] = []
    
    init(style: ACSContainerStyle, hostConfig: ACSHostConfig) {
        super.init(style: style, parentStyle: nil, hostConfig: hostConfig, superview: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTarget(_ target: TargetHandler) {
        targets.append(target)
    }
    
    func addInputHandler(_ handler: InputHandlingViewProtocol) {
        inputHandlers.append(handler)
    }
}

extension ACRView: TargetHandlerDelegate {
    func handleOpenURLAction(button: NSButton, urlString: String) {
        delegate?.acrView(self, didSelectOpenURL: urlString, button: button)
    }
    
    func handleSubmitAction(button: NSButton) {
        var dict = [String: String]()
        for handler in inputHandlers {
            guard handler.isValid else { continue }
            dict[handler.key] = handler.value
        }
        delegate?.acrInputViewHandler(self, didSubmitUserResponses: dict, button: button)
    }
}
