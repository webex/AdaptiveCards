import AdaptiveCards_bridge
import AppKit

class ACRCollectionView: NSScrollView {
    private struct Constants {
        static let spacing: CGFloat = 12
        static let focusRingPadding: CGFloat = 8
    }
    
    private let imageSet: ACSImageSet
    private let imageSize: ACSImageSize
    private let hostConfig: ACSHostConfig
    private let imageViews: [ACRImageWrappingView]
    
    private var itemSize: CGSize {
        switch imageSize {
        case .none, .auto, .stretch:
            return ImageUtils.getImageSizeAsCGSize(imageSize: .medium, with: hostConfig)
        default:
            return ImageUtils.getImageSizeAsCGSize(imageSize: imageSize, with: hostConfig)
        }
    }
    
    private(set) lazy var collectionView: NSCollectionView = {
        let view = NSCollectionView()
        view.itemPrototype = nil
        view.backgroundColors = [.clear]
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Need to be able to inject layout for testing purpose
    init(rootView: ACRView, parentView: NSView, imageSet: ACSImageSet, hostConfig: ACSHostConfig, collectionLayout: NSCollectionViewLayout = ACSCollectionViewAlignLayout(), frameRect: NSRect = .zero) {
        self.imageSet = imageSet
        self.hostConfig = hostConfig
        let imageSetImageSize: ACSImageSize = (imageSet.getImageSize() == .none || imageSet.getImageSize() == .auto || imageSet.getImageSize() == .stretch) ? .medium : imageSet.getImageSize()
        self.imageSize = imageSetImageSize
        self.imageViews = imageSet.getImages().map {
            let imageWrappingView = ImageUtils.getImageWrappingViewFor(element: $0, hostConfig: hostConfig, rootView: rootView, parentView: parentView, isImageSet: true, imageSetImageSize: imageSetImageSize)
            return imageWrappingView
        }
        super.init(frame: frameRect)
        collectionView.collectionViewLayout = collectionLayout
        collectionView.register(ACRCollectionViewItem.self, forItemWithIdentifier: ACRCollectionViewItem.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        needsLayout = true
        wantsLayer = true
        documentView = collectionView
        
        // hide scroller
        hasVerticalScroller = false
        hasHorizontalScroller = false
        scrollerInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        scrollerStyle = .overlay
        autohidesScrollers = true
    }
    
    // Calculate ContentSize for CollectionView
    private func collectionViewContentSize() -> CGSize? {
        guard !imageSet.getImages().isEmpty, !self.bounds.width.isZero else {
            return nil
        }
        let itemCount = imageSet.getImages().count
        let interItemSpacing = Constants.spacing
        let frameWidth = self.bounds.width
        var totalHeight = CGFloat.zero
        var maxHeight = CGFloat.zero
        var rowWidth = CGFloat.zero
        
        for index in 0..<itemCount {
            if let imgItemProperties = imageViews[index].imageProperties {
                var explicitDimensions = NSSize.zero
                if imgItemProperties.hasExplicitDimensions && imgItemProperties.pixelWidth.isNormal && imgItemProperties.pixelHeight.isNormal {
                    explicitDimensions = NSSize(width: imgItemProperties.pixelWidth > self.bounds.width ? self.bounds.width : imgItemProperties.pixelWidth, height: imgItemProperties.pixelHeight).deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                } else if imgItemProperties.hasExplicitDimensions && (imgItemProperties.pixelWidth.isNormal || imgItemProperties.pixelHeight.isNormal) {
                    if let contentSize = imageViews[index].imageProperties?.contentSize {
                        explicitDimensions = contentSize.deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                    } else {
                        let maxValue = max(imgItemProperties.pixelWidth, imgItemProperties.pixelHeight)
                        explicitDimensions = NSSize(width: maxValue, height: maxValue).deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                    }
                } else {
                    if let contentSize = imageViews[index].imageProperties?.contentSize {
                        explicitDimensions = contentSize.deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                    } else {
                        explicitDimensions = itemSize.deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                    }
                }
                let tempWidth = (rowWidth + explicitDimensions.width)
                if tempWidth <= frameWidth {
                    rowWidth += explicitDimensions.width + interItemSpacing
                    maxHeight = max(maxHeight, explicitDimensions.height)
                } else {
                    // add old
                    totalHeight += maxHeight + interItemSpacing
                    // start new
                    maxHeight = explicitDimensions.height
                    rowWidth = explicitDimensions.width + interItemSpacing
                }
                if index == itemCount - 1 {
                    totalHeight += maxHeight
                }
            }
        }
        return CGSize(width: frameWidth, height: totalHeight)
    }
    
    var pBoundsWidth: CGFloat?
    var pContentSize: CGSize?
    override func layout() {
        super.layout()
        guard window != nil, pBoundsWidth != bounds.width else { return }
        pBoundsWidth = bounds.width
        pContentSize = nil
    }
    
    override var intrinsicContentSize: NSSize {
        guard let contentSize = pContentSize else {
            guard let calcSize = collectionViewContentSize() else {
                return super.intrinsicContentSize
            }
            pContentSize = calcSize
            return calcSize
        }
        return contentSize
    }
    
    override func scrollWheel(with event: NSEvent) {
        // to disable scroll always
        nextResponder?.scrollWheel(with: event)
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let view = superview else { return }
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

extension ACRCollectionView: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSet.getImages().count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: ACRCollectionViewItem.identifier, for: indexPath) as? ACRCollectionViewItem else { return NSCollectionViewItem() }
        item.setupBounds(with: imageViews[indexPath.item])
        return item
    }
}

extension ACRCollectionView: ACSCollectionViewAlignLayoutDelegate {
    func collectionView(_ collectionView: ACSCollectionView, layout: ACSCollectionViewAlignLayout, itemsVerticalAlignmentInSection section: Int) -> ACSCollectionViewItemsVerticalAlignment {
        return .top
    }
    
    func collectionView(_ collectionView: ACSCollectionView, layout: ACSCollectionViewAlignLayout, itemsHorizontalAlignmentInSection section: Int) -> ACSCollectionViewItemsHorizontalAlignment {
        return .left
    }
    
    func collectionView(_ collectionView: ACSCollectionView, layout: ACSCollectionViewAlignLayout, itemsDirectionInSection section: Int) -> ACSCollectionViewItemsDirection {
        return .LTR
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard let itemProperties = imageViews[indexPath.item].imageProperties else { return itemSize }
        if itemProperties.hasExplicitDimensions {
            var size = NSSize.zero
            if !itemProperties.pixelWidth.isZero && !itemProperties.pixelHeight.isZero {
                size = NSSize(width: itemProperties.pixelWidth > self.bounds.width ? self.bounds.width : itemProperties.pixelWidth, height: itemProperties.pixelHeight).deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                return size
            } else if itemProperties.pixelWidth.isNormal || itemProperties.pixelHeight.isNormal {
                if let contentSize = imageViews[indexPath.item].imageProperties?.contentSize {
                    size = contentSize.deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                    return size
                }
                let maxValue = max(itemProperties.pixelWidth, itemProperties.pixelHeight)
                size = NSSize(width: maxValue, height: maxValue).deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
                return size
            }
        } else {
            if let contentSize = imageViews[indexPath.item].imageProperties?.contentSize {
                return contentSize.deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
            }
        }
        return itemSize.deltaBy(dW: Constants.focusRingPadding, dH: Constants.focusRingPadding)
    }
}

extension NSSize {
    func deltaBy(dW: Double, dH: Double) -> NSSize {
        return NSSize(width: self.width + dW, height: self.height + dH)
    }
}
