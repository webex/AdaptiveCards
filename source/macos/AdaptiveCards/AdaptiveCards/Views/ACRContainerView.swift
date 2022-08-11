//
//  ACRContainerView.swift
//  AdaptiveCards
//
//  Created by uchauhan on 27/07/22.
//

import AdaptiveCards_bridge
import AppKit

class ACRContainerView: ACRContentStackView {
    private (set) lazy var backgroundImageView: ACRBackgroundImageView = {
        let view = ACRBackgroundImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var widthConstraint = widthAnchor.constraint(equalToConstant: 30)
    private lazy var backgroundImageViewBottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    private lazy var backgroundImageViewTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: topAnchor)
    private lazy var backgroundImageViewLeadingConstraint = backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var backgroundImageViewTrailingConstraint = backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
    
    override func setupViews() {
        addSubview(backgroundImageView)
        super.setupViews()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        backgroundImageViewTopConstraint.isActive = true
        backgroundImageViewLeadingConstraint.isActive = true
        backgroundImageViewTrailingConstraint.isActive = true
        backgroundImageViewBottomConstraint.isActive = true
    }
    
    override func addArrangedSubview(_ subview: NSView) {
        super.addArrangedSubview(subview)
        if subview is ACRImageWrappingView {
            // We don't need to include Image view Intrinsic Content Size inside the container because it's handle by their own Intrinsic Content Size, so we won't need to add their size separately.
            return
        }
        increaseIntrinsicContentSize(subview)
    }
    
    override func insertArrangedSubview(_ view: NSView, at insertionIndex: Int) {
        super.insertArrangedSubview(view, at: insertionIndex)
        increaseIntrinsicContentSize(view)
    }
    
    override func increaseIntrinsicContentSize(_ view: NSView) {
        if !view.isHidden {
            super.increaseIntrinsicContentSize(view)
            let size = view.intrinsicContentSize
            if size.width >= 0 && size.height >= 0 {
                let combinedSize = CGSize(width: max(self.combinedContentSize.width, size.width), height: self.combinedContentSize.height + size.height)
                self.combinedContentSize = combinedSize
            }
        }
    }

    override func decreaseIntrinsicContentSize(_ view: NSView) {
        // get max height amongst the subviews that is not the view
        let maxWidthExcludingTheView = getMaxWidthOfSubviews(afterExcluding: view)
        let size = getIntrinsicContentSize(inArragedSubviews: view)
        // there are three possible cases
        // 1. possibleMaxWidthExcludingTheView is equal to the height of the view
        // 2. possibleMaxWidthExcludingTheView is bigger than the the height of the view
        // 3. possibleMaxWidthExcludingTheView is smaller than the the height of the view
        // only #3 changes the current height, when the view's height is no longer in considreation
        // for dimension
        let newWidth = (maxWidthExcludingTheView < size.width) ? maxWidthExcludingTheView : combinedContentSize.width
        self.combinedContentSize = CGSize(width: newWidth, height: self.combinedContentSize.height - size.height)
    }
    
    override func updateIntrinsicContentSize() {
        self.combinedContentSize = CGSize.zero
        super.updateIntrinsicContentSize({ [self] view, id, bool in
            print(view, id, bool)
            guard let view = view as? NSView else { return }
            let size = view.intrinsicContentSize
            guard !view.isHidden else { return }
            guard size.width >= 0 && size.height >= 0 else { return }
            let combinedSize = CGSize(width: max(self.combinedContentSize.width, size.width), height: self.combinedContentSize.height + size.height)
            combinedContentSize = combinedSize
        })
    }
    
    func setupBackgroundImageProperties(_ properties: ACSBackgroundImage) {
        backgroundImageView.fillMode = properties.getFillMode()
        backgroundImageView.horizontalAlignment = properties.getHorizontalAlignment()
        backgroundImageView.verticalAlignment = properties.getVerticalAlignment()
        heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
    
    func bleedBackgroundImage(padding: CGFloat, top: Bool, bottom: Bool, leading: Bool, trailing: Bool, paddingBottom: CGFloat, with anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        backgroundImageViewTopConstraint.constant = top ? -padding : 0
        backgroundImageViewTrailingConstraint.constant = trailing ? padding : 0
        backgroundImageViewLeadingConstraint.constant = leading ? -padding : 0
        backgroundImageViewBottomConstraint.isActive = false
        backgroundImageViewBottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: anchor, constant: bottom ?  padding : 0)
        backgroundImageViewBottomConstraint.isActive = true
    }
}
