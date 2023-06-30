//
//  ACRColumnSetView.swift
//  AdaptiveCards
//
//  Created by uchauhan on 03/08/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRColumnSetView: ACRContentStackView {
    // AccessibleFocusView property
    override var validKeyView: NSView? {
        get {
            return self
        }
        set { }
    }
    
    override func addArrangedSubview(_ view: NSView) {
        super.addArrangedSubview(view)
        self.increaseIntrinsicContentSize(view)
    }
    
    override func addView(_ view: NSView, in gravity: NSStackView.Gravity) {
        super.addView(view, in: gravity)
        self.increaseIntrinsicContentSize(view)
    }
    
    override func setupInternalKeyviews() {
        self.nextKeyView = self.exitView?.validKeyView
    }
    
    override func increaseIntrinsicContentSize(_ view: NSView) {
        if !view.isHidden {
            super.increaseIntrinsicContentSize(view)
            let size = view.intrinsicContentSize
            if size.width >= 0 && size.height >= 0 {
                let combinedSize = CGSize(width: self.combinedContentSize.width + size.width, height: max(self.combinedContentSize.height, size.height))
                self.combinedContentSize = combinedSize
            }
        }
    }
    
    override func decreaseIntrinsicContentSize(_ view: NSView) {
        // get max height amongst the subviews that is not the view
        let maxHeightExludingTheView = getMaxHeightOfSubviews(afterExcluding: view)
        let size = getIntrinsicContentSize(inArragedSubviews: view)
        // there are three possible cases
        // 1. maxHeightExludingTheView is equal to the height of the view
        // 2. maxHeightExludingTheView is bigger than the the height of the view
        // 3. maxHeightExludingTheView is smaller than the the height of the view
        // only #3 changes the current height, when the view's height is no longer in considreation
        // for dimension
        let newHeight = (maxHeightExludingTheView < size.height) ? maxHeightExludingTheView : combinedContentSize.height
        self.combinedContentSize = CGSize(width: combinedContentSize.width - size.width, height: newHeight)
    }
    
    override func updateIntrinsicContentSize() {
        combinedContentSize = CGSize.zero
        super.updateIntrinsicContentSize({ [self] view, _, _ in
            guard let view = view as? NSView else { return }
            let size = view.intrinsicContentSize
            guard size.width >= 0 && size.height >= 0 else { return }
            let combinedSize = CGSize(width: combinedContentSize.width + size.width, height: CGFloat(max(combinedContentSize.height, size.height)))
            combinedContentSize = combinedSize
        })
    }
    
    /// call this method after subview is rendered
    /// it configures height, creates association between the subview and its separator if any
    /// registers subview for its visibility
    override func updateLayoutAndVisibilityOfRenderedView(_ renderedView: NSView, acoElement acoElem: ACSBaseCardElement, separator: SpacingView?, rootView: ACRView?) {
        if let separator = separator {
            self.associateSeparator(withOwnerView: separator, ownerView: renderedView)
        }
        rootView?.visibilityContext?.registerVisibilityManager(self, targetViewIdentifier: renderedView.identifier)
        if !acoElem.getIsVisible() {
            self.register(invisibleView: renderedView)
        }
    }
    
    override func configureLayoutAndVisibility(minHeight: NSNumber?) {
        self.applyVisibilityToSubviews()
        self.setMinimumHeight(minHeight)
    }
    
    override func setBleedViewConstraint(direction: (top: Bool, bottom: Bool, leading: Bool, trailing: Bool), with padding: CGFloat) {
        // adding this below stackView
        addSubview(bleedView, positioned: .below, relativeTo: self.stackView)
        super.setBleedViewConstraint(direction: direction, with: padding)
    }
}
