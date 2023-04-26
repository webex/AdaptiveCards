@testable import AdaptiveCards
import AppKit

extension NSButton {
    func performClick() {
        guard !isHidden else { return }
        if let flatButton = self as? FlatButton, !flatButton.momentary {
            state = state == .on ? .off : .on
        }
        if let target = target, let action = action {
            sendAction(action, to: target)
        }
    }
}

extension NSView {
    func buttonInHierachy(withTitle title: String) -> NSButton? {
        guard !subviews.isEmpty else {
            return nil
        }
        for subview in subviews {
            if let button = subview as? NSButton, button.title == title {
                return button
            }
            if let button = subview.buttonInHierachy(withTitle: title) {
                return button
            }
        }
        return nil
    }
    
    func getView(with id: String, in view: NSView) -> NSView? {
        if view.subviews.isEmpty {
            return nil
        }
        for subView in view.subviews {
            if subView.identifier?.rawValue == id {
                return subView
            }
            if let inSubview = getView(with: id, in: subView) {
                return inSubview
            }
        }
        return nil
    }
}

class FakeErrorMessageHandlerDelegate: InputHandlingViewErrorDelegate {
    func isErrorVisible(_ view: InputHandlingViewProtocol) -> Bool {
        
        return isErrorVisible
    }
    
    var isErrorVisible: Bool = false
    var isErrorMessageAnnounced: Bool = false
    func inputHandlingViewShouldShowError(_ view: InputHandlingViewProtocol) {
        isErrorVisible = true
    }
    
    func inputHandlingViewShouldHideError(_ view: InputHandlingViewProtocol, currentFocussedView: NSView?) {
        isErrorVisible = false
    }
    
    func inputHandlingViewShouldAnnounceErrorMessage(_ view: InputHandlingViewProtocol, message: String?) {
        isErrorMessageAnnounced = true
    }
}
