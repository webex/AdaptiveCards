import AppKit

extension NSView {
    var isMouseInView: Bool {
        let location = NSEvent.mouseLocation
        guard let windowLocation = window?.convertPoint(fromScreen: location) else { return false }
        let viewLocation = convert(windowLocation, from: nil)
        return bounds.contains(viewLocation)
    }
    
    var isViewInFocus: Bool {
        // This takes care of textField/buttons
        if let controlElement = self as? NSControl, let cell = controlElement.cell, cell.isAccessibilityFocused() {
            return true
        }
        // For special case of multiline textFields wich are subclassed fron NSTextView
        if let textView = self as? NSTextView, textView.isAccessibilityFocused() {
            return true
        }
        return false
    }
}
