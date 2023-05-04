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
    
    func constraint(toFill view: NSView, padding: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }
    
    func findView(withIdentifier identifier: String) -> NSView? {
        // find view in self card
        guard let targetedSubview = getSubView(with: identifier, in: self) else {
            var toggledViewToReturn: NSView?
            // checking if parent card exists
            guard var superView = getSuperView(for: self) else { return nil }
            // finding view in parent card
            toggledViewToReturn = getSubView(with: identifier, in: superView)
            
            // if parent card does not have view too , chekcing for view in further cards up the hierarchy
            while superView.superview != nil && toggledViewToReturn == nil {
                if let sView = getSuperView(for: superView) {
                    toggledViewToReturn = getSubView(with: identifier, in: sView)
                    superView = sView
                } else {
                    return toggledViewToReturn
                }
            }
            return toggledViewToReturn
        }
        return targetedSubview
    }
    
    private func getSubView(with id: String, in view: NSView) -> NSView? {
        if view.subviews.isEmpty {
            return nil
        }
        // This condition is used for finding the correct image cell using its ID within an ImageSet. It is an efficient method for easily finding the desired image element. However, when a collectionview is placed under a scrollview while using the subviews method, it may require more iterations to traverse deeper levels, making it difficult to find the correct image cell.
        if let collectionView = view as? ACRCollectionView {
            if let imageViewCell = collectionView.imageCell(with: id) {
                return imageViewCell
            }
        } else {
            for subView in view.subviews {
                if subView == self {
                    return nil
                }
                if subView.identifier?.rawValue == id {
                    return subView
                }
                if let inSubview = getSubView(with: id, in: subView) {
                    return inSubview
                }
            }
        }
        return nil
    }
    
    private func getSuperView(for view: NSView?) -> NSView? {
        guard let superView = view?.superview else { return nil }
        
        if superView.isKind(of: ACRView.self) {
            return superView
        } else {
            return getSuperView(for: superView)
        }
    }
}
