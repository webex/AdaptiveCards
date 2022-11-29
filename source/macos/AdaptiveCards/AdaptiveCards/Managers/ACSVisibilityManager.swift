//
//  ACSVisibilityManager.swift
//  AdaptiveCards
//
//  Created by uchauhan on 30/08/22.
//
//  This class is designed to handle the visibility of views as well as the corresponding padding or separator. Class also depended on Filler Space Manager to find associated views.

import AdaptiveCards_bridge
import AppKit

/// VisibilityManager protocols for handle element visibility
@objc protocol ACSVisibilityManagerFacade {
    func visibilityManager(hideView view: NSView)
    func visibilityManager(unhideView view: NSView)
    func visibilityManagerAllStretchableViewsHidden() -> Bool
    func visibilityManagerSetLastStretchableView(isHidden: Bool)
    func visibilityManagerUpdateConstraint()
}

class ACSVisibilityManager {
    /// tracks objects that are used in filling the space
    let fillerSpaceManager = ACSFillerSpaceManager()
    
    /// tracks visible views
    private let visibleViews = NSMutableOrderedSet()
    
    var hasVisibleViews: Bool { return !visibleViews.set.isEmpty }
    
    init() { }
    
    /// adds index of a visible view to a visible views collection, and the index is maintained in sorted order
    /// in increasing order.
    func addVisibleView(_ index: Int) {
        let indexAsNumber = NSNumber(value: index)
        if visibleViews.contains(indexAsNumber) { return }
        let range = NSRange(location: 0, length: visibleViews.count)
        /// visibility views hold only index of view, therefore we manage index order.
        let insertionIndex = visibleViews.index(of: indexAsNumber, inSortedRange: range, options: .insertionIndex, usingComparator: { num0, num1 in
            if let n1 = num0 as? NSNumber, let n2 = num1 as? NSNumber {
                return n1.compare(n2)
            }
            return .orderedSame
        })
        visibleViews.insert(indexAsNumber, at: insertionIndex)
    }
    
    /// removes the index of view from the visible views collection
    /// maintain the sorted order after the removal
    func removeVisibleView(at index: Int) {
        let indexAsNumber = NSNumber(value: index)
        if !visibleViews.contains(indexAsNumber) { return }
        let range = NSRange(location: 0, length: visibleViews.count)
        /// visibility views hold only index of view, therefore we manage index order.
        let removalIndex = visibleViews.index(of: indexAsNumber, inSortedRange: range, options: .insertionIndex, usingComparator: { num0, num1 in
            if let n1 = num0 as? NSNumber, let n2 = num1 as? NSNumber {
                return n1.compare(n2)
            }
            return .orderedSame
        })
        visibleViews.removeObject(at: removalIndex)
    }
    
    /// YES means the index of view is currently the leading or top view
    func isHead(_ index: Int) -> Bool {
        let indexAsNumber = NSNumber(value: index)
        guard let firstObj = visibleViews.firstObject as? NSNumber else { return false }
        return hasVisibleViews && (firstObj == indexAsNumber)
    }
    
    /// returns the current leading or top view's index
    func getHeadIndexOfVisibleViews() -> Int {
        guard hasVisibleViews, let firstObj = visibleViews.firstObject as? NSNumber else { return NSNotFound }
        return firstObj.intValue
    }
    
    /// change the visibility of the separator of a host view to `visibility`
    /// `isHidden` `YES` indicates that the separator will be hidden
    func changeVisiblityOfSeparator(_ hostView: NSView, visibilityHidden isHidden: Bool, contentStackView: ACRContentStackView) {
        guard let separtor = fillerSpaceManager.getSeparatorFor(ownerView: hostView) else {
            logInfo("couldn't found separator in filler manager..")
            return
        }
        guard separtor.isHidden != isHidden else { return }
        separtor.isHidden = isHidden
        if isHidden {
            contentStackView.decreaseIntrinsicContentSize(separtor)
        } else {
            contentStackView.increaseIntrinsicContentSize(separtor)
        }
    }
    
    /// change the visibility of the padding of a host view to `visibility`
    /// `isHidden` `YES` indicates that the padding will be hidden
    func changeVisibilityOfPadding(_ hostView: NSView, visibilityHidden isHidden: Bool) {
        guard let spacerViews = fillerSpaceManager.getFillerSpaceView(hostView) else {
            logInfo("couldn't found padding in filler manager..")
            return
        }
        for value in spacerViews {
            let padding = value.nonretainedObjectValue as? NSView
            if padding?.isHidden != isHidden {
                padding?.isHidden = isHidden
            }
        }
    }
    
    /// change the visibility of the padding(s) and separator of a host view to `visibility`
    /// `visibility` `YES` indicates that the padding will be hidden
    func changeVisiblityOfAssociatedViews(hostView: NSView, visibilityValue visibility: Bool, contentStackView: ACRContentStackView) {
        changeVisibilityOfPadding(hostView, visibilityHidden: visibility)
        changeVisiblityOfSeparator(hostView, visibilityHidden: visibility, contentStackView: contentStackView)
    }
    
    /// hide `viewToBeHidden`. `hostView` is a superview of type ColumnView or ColumnSetView
    func hide(_ viewToBeHidden: NSView, hostView: ACRContentStackView) {
        let subviews = hostView.stackView.subviews
        let index = subviews.firstIndex(of: viewToBeHidden) ?? NSNotFound
        guard index != NSNotFound else { return }
        let isHead = self.isHead(index)
        self.removeVisibleView(at: index)
        
        // setting hidden view to hidden again is a programming error
        // as it requires to have equal or more times of the opposite value to be set
        // in order to reverse it
        if !viewToBeHidden.isHidden {
            viewToBeHidden.isHidden = true
            // decrease the intrinsic content size by the intrinsic content size of
            // `viewToBeHidden` otherwise, viewTobeHidden's size will be included
            hostView.decreaseIntrinsicContentSize(viewToBeHidden)
            if let inputView = viewToBeHidden as? InputHandlingViewProtocol {
                if let errorLabel = hostView.getErrorTextField(for: inputView) {
                    hostView.decreaseIntrinsicContentSize(errorLabel)
                }
                if let label = hostView.getLabelTextField(for: inputView) {
                    hostView.decreaseIntrinsicContentSize(label)
                }
            }
            self.changeVisiblityOfAssociatedViews(hostView: viewToBeHidden, visibilityValue: true, contentStackView: hostView)
        }
        // if `viewToBeHidden` is a head, get new head if any, and hide its separator
        if isHead {
            let headIndex = self.getHeadIndexOfVisibleViews()
            if headIndex != NSNotFound && headIndex < subviews.count {
                let headView = subviews[headIndex]
                changeVisiblityOfSeparator(headView, visibilityHidden: true, contentStackView: hostView)
            }
        }
    }
    
    /// unhide `viewToBeUnhidden`. `hostView` is a superview of type ColumnView or ColumnSetView
    func unhideView(_ viewToBeUnhidden: NSView, hostView: ACRContentStackView) {
        let subviews = hostView.stackView.subviews
        let index = subviews.firstIndex(of: viewToBeUnhidden) ?? NSNotFound
        guard index != NSNotFound else { return }
        let headIndex = self.getHeadIndexOfVisibleViews()
        self.addVisibleView(index)
        let isHead = self.isHead(index)
        // check if the unhidden view will become a head
        if isHead {
            // only enable filler view associated with the `viewTobeUnhidden`
            self.changeVisibilityOfPadding(viewToBeUnhidden, visibilityHidden: false)
            if viewToBeUnhidden.isHidden {
                viewToBeUnhidden.isHidden = false
                hostView.increaseIntrinsicContentSize(viewToBeUnhidden)
            }
            // previous head view's separator becomes visible
            if headIndex != NSNotFound && headIndex < subviews.count {
                let prevHeadView = subviews[headIndex]
                changeVisiblityOfSeparator(prevHeadView, visibilityHidden: false, contentStackView: hostView)
            }
        } else {
            if viewToBeUnhidden.isHidden {
                viewToBeUnhidden.isHidden = false
                hostView.increaseIntrinsicContentSize(viewToBeUnhidden)
            }
            self.changeVisiblityOfAssociatedViews(hostView: viewToBeUnhidden, visibilityValue: false, contentStackView: hostView)
        }
    }
    
    func changeVisibilityOfLastStretchableView(isHidden: Bool) {
        fillerSpaceManager.toggleLastStretchableViewVisibility(isHidden: isHidden)
    }
}
