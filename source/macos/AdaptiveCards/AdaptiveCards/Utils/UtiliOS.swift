import AdaptiveCards_bridge
import AppKit

struct ACRBleedDirection: OptionSet {
    let rawValue: UInt
    
    static let ACRBleedRestricted = ACRBleedDirection(rawValue: 0 << 0)
    static let ACRBleedToLeadingEdge = ACRBleedDirection(rawValue: 1 << 0)
    static let ACRBleedToTrailingEdge = ACRBleedDirection(rawValue: 1 << 1)
    static let ACRBleedToTopEdge = ACRBleedDirection(rawValue: 1 << 2)
    static let ACRBleedToBottomEdge = ACRBleedDirection(rawValue: 1 << 3)
    static let ACRBleedToAll: ACRBleedDirection = [.ACRBleedToBottomEdge, .ACRBleedToLeadingEdge, .ACRBleedToTrailingEdge, .ACRBleedToTopEdge]
}

class BleedConfiguration {
    static func configBleed(container: NSView, rootView: ACRColumnView, with hostConfig: ACSHostConfig, element: ACSBaseCardElement, isFirstElement: Bool, superview: NSView) {
        if !(element is ACSCollectionTypeElement) {
            return
        }
        guard let collection = element as? ACSCollectionTypeElement else {
            logError("Element is not ACSCollectionTypeElement")
            return
        }
        if !collection.getBleed() {
            return
        }
        // bleed specification requires the object that's asked to be bled to have padding
        if collection.getPadding() {
            let adaptiveBleedDirection = collection.getBleedDirection()
            let direction = ACRBleedDirection(rawValue: adaptiveBleedDirection.rawValue)
            
            // 1. create a background view (bv).
            // 2. Now, add bv to the rootView
            // bv is then pinned to the rootView to the bleed direction
            // bv gets current collection view's (cv) container style
            // container view's stack view (csv) holds content views, and bv dislpays
            // container style we transpose them, and get the final result
            
            let backgroundView = NSView()
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            let backgroundViewTwo = NSView()
            backgroundViewTwo.translatesAutoresizingMaskIntoConstraints = false
            
            if let containerView = container as? ACRColumnView {
                containerView.backgroundView = backgroundView
            }
            var viewTwo: Bool = false
            
            // if parent already has a bv, then it means parentView is bleeding as well,
            // so child will bleed from parent to rootView, adding two bv, one above rootView backgroundImageView and other above parent backgroundImageView
            if let parentBackgroundView = rootView.backgroundView {
                superview.addSubview(backgroundView, positioned: .above, relativeTo: parentBackgroundView)
                rootView.addSubview(backgroundViewTwo, positioned: .above, relativeTo: rootView.backgroundImageView)
                viewTwo = true
            } else if rootView.style == ACSContainerStyle.none || rootView.style == .default {
                // this else is adding because if parent has none or default child, the child will bleed to rootView, so using the same approach
                if let superView = superview as? ACRColumnView {
                    superView.addSubview(backgroundView, positioned: .above, relativeTo: superView.backgroundImageView)
                    rootView.addSubview(backgroundViewTwo, positioned: .above, relativeTo: rootView.backgroundImageView)
                    viewTwo = true
                }
            } else {
                // this is normal approach adding a bv to the rootView and adding properties to it
                rootView.addSubview(backgroundView, positioned: .above, relativeTo: rootView.backgroundImageView)
            }
            
            backgroundView.wantsLayer = true
            backgroundView.layer?.backgroundColor = container.layer?.backgroundColor
            // adding this above parentView backgroundImage view to overcome that color thing
            backgroundViewTwo.wantsLayer = true
            backgroundViewTwo.layer?.backgroundColor = container.layer?.backgroundColor
            
            let top = ((direction.rawValue & ACRBleedDirection.ACRBleedToTopEdge.rawValue) != 0)
            let leading = ((direction.rawValue & ACRBleedDirection.ACRBleedToLeadingEdge.rawValue) != 0)
            let trailing = ((direction.rawValue & ACRBleedDirection.ACRBleedToTrailingEdge.rawValue) != 0)
            let bottom = ((direction.rawValue & ACRBleedDirection.ACRBleedToBottomEdge.rawValue) != 0)
            
            // if we want to add second background view to our view
            if viewTwo {
                if isFirstElement, top {
                    backgroundViewTwo.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
                } else {
                    backgroundViewTwo.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
                }
                if leading {
                    backgroundViewTwo.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
                } else {
                    backgroundViewTwo.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                }
                if trailing {
                    backgroundViewTwo.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
                } else {
                    backgroundViewTwo.leadingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
                }
                if bottom {
                    backgroundViewTwo.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
                } else {
                    backgroundViewTwo.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
                }
            }
            
            // parentview style is none or default
            if rootView.style == ACSContainerStyle.none || rootView.style == .default {
                if isFirstElement, top {
                    backgroundView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
                } else {
                    backgroundView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
                }
                if leading {
                    backgroundView.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
                } else {
                    backgroundView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                }
                if trailing {
                    backgroundView.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
                } else {
                    backgroundView.leadingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
                }
                if bottom {
                    backgroundView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
                } else {
                    backgroundView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
                }
            } else {
                // normal approach
                if isFirstElement, top {
                    if let parentbackgroundView = rootView.backgroundView {
                        backgroundView.topAnchor.constraint(equalTo: parentbackgroundView.topAnchor).isActive = true
                    } else {
                        backgroundView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
                    }
                } else {
                    backgroundView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
                }
                if leading {
                    if let parentbackgroundView = rootView.backgroundView {
                        backgroundView.leadingAnchor.constraint(equalTo: parentbackgroundView.leadingAnchor).isActive = true
                    } else {
                        backgroundView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
                    }
                } else {
                    backgroundView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                }
                if trailing {
                    if let parentbackgroundView = rootView.backgroundView {
                        backgroundView.trailingAnchor.constraint(equalTo: parentbackgroundView.trailingAnchor).isActive = true
                    } else {
                        backgroundView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
                    }
                } else {
                    backgroundView.leadingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
                }
                if bottom {
                    if let parentbackgroundView = rootView.backgroundView {
                        backgroundView.bottomAnchor.constraint(equalTo: parentbackgroundView.bottomAnchor).isActive = true
                    } else {
                        backgroundView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
                    }
                } else {
                    backgroundView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
                }
            }
            
            if let borderWidth = container.layer?.borderWidth {
                backgroundView.layer?.borderWidth = borderWidth
//                container.layer?.borderWidth = 0
            }
            
            if let borderColor = container.layer?.borderColor {
                backgroundView.layer?.borderColor = borderColor
//                container.layer?.borderColor = .clear
            }
        }
    }
}
