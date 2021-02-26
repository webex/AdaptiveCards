import AdaptiveCards_bridge
import AppKit

class BaseCardElementRenderer {
    func updateView(view: NSView, element: ACSBaseCardElement, style: ACSContainerStyle, hostConfig: ACSHostConfig) -> NSView {
        view.isHidden = !element.getIsVisible()
        return view
    }
}
