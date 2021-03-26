import AdaptiveCards_bridge
import AppKit

struct ACRBleedDirection: OptionSet {
    let rawValue: UInt
    
    init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    static let ACRBleedRestricted = ACRBleedDirection(rawValue: 0 << 0)
    static let ACRBleedToLeadingEdge = ACRBleedDirection(rawValue: 1 << 0)
    static let ACRBleedToTrailingEdge = ACRBleedDirection(rawValue: 1 << 1)
    static let ACRBleedToTopEdge = ACRBleedDirection(rawValue: 1 << 2)
    static let ACRBleedToBottomEdge = ACRBleedDirection(rawValue: 1 << 3)
    static let ACRBleedToAll: ACRBleedDirection = [.ACRBleedToBottomEdge, .ACRBleedToLeadingEdge, .ACRBleedToTrailingEdge, .ACRBleedToTopEdge]
}

class BleedConfiguration {
    static func bleedRequired(container: NSView, rootView: ACRView, with hostConfig: ACSHostConfig, element: ACSBaseCardElement, parentView: NSView?) {
        // do something
        guard let collection = element as? ACSCollectionTypeElement else {
            logError("Element is not ACSCollectionTypeElement")
            return
        }
        if !collection.getBleed() {
            return
        }
        // check current collection type element has padding, if so added to the padding map
        // bleed specification requires the object that's asked to be bled to have padding
        if collection.getPadding() {
            let adaptiveBleedDirection = collection.getBleedDirection()
            let direction = ACRBleedDirection(rawValue: adaptiveBleedDirection.rawValue)
            
            // 1. create a background view (bv).
            // 2. bv is added to bleed target view (tv), which is also a parent view.
            // bv is then pinned to the tv according to the bleed direction
            // bv gets current container view's (cv) container style
            // and cv's container style is reset to transparent, such that
            // bv's container style will be diplayed.
            // container view's stack view (csv) holds content views, and bv dislpays
            // container style we transpose them, and get the final result
            
            let backgroundView = NSView()
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            rootView.backgroundView = backgroundView
            
            rootView.addSubview(backgroundView, positioned: .above, relativeTo: rootView.backgroundImageView)
            backgroundView.wantsLayer = true
            backgroundView.layer?.backgroundColor = container.layer?.backgroundColor
            
            let top = ((direction.rawValue & ACRBleedDirection.ACRBleedToTopEdge.rawValue) != 0)
            let leading = ((direction.rawValue & ACRBleedDirection.ACRBleedToLeadingEdge.rawValue) != 0)
            let trailing = ((direction.rawValue & ACRBleedDirection.ACRBleedToTrailingEdge.rawValue) != 0)
            let bottom = ((direction.rawValue & ACRBleedDirection.ACRBleedToBottomEdge.rawValue) != 0)
            
            if rootView.stackView.arrangedSubviews.count == 1, top {
                backgroundView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
            } else {
                backgroundView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            }
            if leading {
                backgroundView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
            }
            if trailing {
                backgroundView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
            }
            
            if (direction.rawValue & ACRBleedDirection.ACRBleedToBottomEdge.rawValue) != 0, bottom {
                backgroundView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
            } else {
                backgroundView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            }
            
            if let borderWidth = container.layer?.borderWidth {
                backgroundView.layer?.borderWidth = borderWidth
            }
            
            if let borderColor = container.layer?.borderColor {
                backgroundView.layer?.borderColor = borderColor
            }
        }
    }
}
