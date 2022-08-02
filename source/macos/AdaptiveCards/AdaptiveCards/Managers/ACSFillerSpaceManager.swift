//
//  ACSFillerSpaceManager.swift
//  AdaptiveCards
//
//  This class design for handle stretchable view inside stackview. class also handling height property for elements.

import AdaptiveCards_bridge
import AppKit

let kFillerViewLayoutConstraintPriority = NSLayoutConstraint.Priority.defaultLow - 10

// Concept behind the FillerSpaceManager.
/// This class use for stretchable padding space
class StretchableView: NSView {
}
///
/// Stretchable maintain with two scenario.
/// CASE I : when there is no stretchable view inside the NSStackView.
/// we are add one dummy padding stretchable view to maintain class stretching and hugging. give hugging and stretching constraint to that view.
/// CASE II : when there is already stretchable view present inside the NSStackView.
/// give hugging and stretching constraint to that view.
/*
 B = StackView
 A = inside subview
 S = stretchable view
 B+------------------------------+
  | A+------------------------+  |
  |  |       H:250            |  |
  |  |       V:250            |  |
  |  +------------------------+  |
  | S+------------------------+  |
  |  |       H:250            |  |
  |  |       V:240            |  |
  |  |                        |  |
  |  |                        |  |
  |  |                        |  |
  |  +------------------------+  |
  +------------------------------+
 */

class ACSFillerSpaceManager {
    private var paddingMap: NSMapTable<NSView, NSMutableArray>
    private var stretchableViewSet: NSHashTable<NSView>
    private var stretchableViews: [NSValue]
    private var paddingSet: NSHashTable<NSView>
    private var paddingConstraints: [NSLayoutConstraint]
    
    init() {
        paddingMap = NSMapTable<NSView, NSMutableArray>(keyOptions: .weakMemory, valueOptions: .strongMemory)
        stretchableViewSet = NSHashTable<NSView>(options: .weakMemory, capacity: 5)
        stretchableViews = [NSValue]()
        paddingSet = NSHashTable<NSView>(options: .weakMemory, capacity: 5)
        paddingConstraints = [NSLayoutConstraint]()
    }
    
    class func configureHugging(view: NSView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(kFillerViewLayoutConstraintPriority, for: .vertical)
    }
    
    /// tells if the owner of this object has padding
    func hasPadding() -> Bool {
        if !stretchableViews.isEmpty {
            for nsValue in stretchableViews {
                if let view = nsValue.nonretainedObjectValue as? NSView {
                    if !view.isHidden {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// configures & adds padding for the `view`
    /// having padding makes the owner of the object,
    /// stretchable
    
    func addPadding(forView view: NSView) -> NSView {
        let padding = StretchableView()
        ACSFillerSpaceManager.configureHugging(view: padding)
        var values = paddingMap.object(forKey: view) as? [NSValue]
        if values == nil {
            values = []
            if let values = values {
                paddingMap.setObject(NSMutableArray(array: values), forKey: view)
            }
        }
        stretchableViewSet.add(padding)
        stretchableViews.append(NSValue(nonretainedObject: padding))
        paddingSet.add(padding)
        values?.append(NSValue(nonretainedObject: padding))
        return padding
    }
    
    /// configures for AdaptiveCards Height property
    /// Image and Media gets their own padding since stretching them are not desirable
    func configureHeight(view: NSView, correspondingElement: ACSBaseCardElement) {
        if correspondingElement.getHeight() == .stretch && (correspondingElement.getType() != .image && correspondingElement.getType() != .media) {
            ACSFillerSpaceManager.configureHugging(view: view)
            stretchableViewSet.add(view)
            stretchableViews.append(NSValue(nonretainedObject: view))
        }
    }
    
    /// activates the constraints together for performance
    /// two stretchable views get same height
    /// by setting low priority, the relationship can be overridden
    /// if it's not possible
    @discardableResult func activateConstraintsForPadding() -> [NSLayoutConstraint]? {
        if stretchableViews.count > 1 {
            var paddingConstraints = [NSLayoutConstraint]()
            var prevPadding: NSView?
            for paddingValue in stretchableViews {
                if let padding = paddingValue.nonretainedObjectValue as? NSView {
                    if let prevPadding = prevPadding {
                        if !padding.isHidden {
                            paddingConstraints.append(prevPadding.heightAnchor.constraint(equalTo: padding.heightAnchor))
                            paddingConstraints.last?.priority = .defaultLow
                        }
                    }
                    if !padding.isHidden {
                        prevPadding = padding
                    }
                }
            }
            if !paddingConstraints.isEmpty {
                NSLayoutConstraint.activate(paddingConstraints)
            }
            return paddingConstraints
        }
        return nil
    }
    
    func deactivateConstraintsForPadding() {
        guard !paddingConstraints.isEmpty else { return }
        NSLayoutConstraint.deactivate(paddingConstraints)
    }
    
    func isPadding(_ padding: NSView) -> Bool {
        return paddingSet.contains(padding)
    }
    
    func getFillerSpaceView(_ view: NSView) -> [NSValue]? {
        return paddingMap.object(forKey: view) as? [NSValue]
    }
}
