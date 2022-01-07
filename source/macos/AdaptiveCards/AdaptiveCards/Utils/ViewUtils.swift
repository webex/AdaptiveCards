import AppKit

extension NSView {
    var isMouseInView: Bool {
        let location = NSEvent.mouseLocation
        guard let windowLocation = window?.convertPoint(fromScreen: location) else { return false }
        let viewLocation = convert(windowLocation, from: nil)
        return bounds.contains(viewLocation)
    }
}
