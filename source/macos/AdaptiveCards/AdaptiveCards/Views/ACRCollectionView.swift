import AdaptiveCards_bridge
import AppKit

class ACRCollectionView: NSScrollView {
    private struct Constants {
        static let padding: CGFloat = 0
    }
    
    private let imageSet: ACSImageSet
    private let imageSize: ACSImageSize
    private let hostConfig: ACSHostConfig
    private let imageViews: [ACRImageWrappingView]
    
    private var itemSize: CGSize {
        switch imageSize {
        case .stretch, .none:
            return ImageUtils.getImageSizeAsCGSize(imageSize: .medium, with: hostConfig)
        case .auto:
            let mediumSize = ImageUtils.getImageSizeAsCGSize(imageSize: .medium, with: hostConfig)
            let itemWidth = min(mediumSize.width, bounds.width - (2 * Constants.padding))
            return CGSize(width: itemWidth, height: itemWidth)
        default:
            return ImageUtils.getImageSizeAsCGSize(imageSize: imageSize, with: hostConfig)
        }
    }
    
    private lazy var collectionView: NSCollectionView = {
        let view = NSCollectionView()
        view.itemPrototype = nil
        view.backgroundColors = [.clear]
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rootView: ACRView, parentView: NSView, imageSet: ACSImageSet, hostConfig: ACSHostConfig) {
        self.imageSet = imageSet
        self.hostConfig = hostConfig
        let imageSetImageSize: ACSImageSize = imageSet.getImageSize() == .none ? .medium : imageSet.getImageSize()
        self.imageSize = imageSetImageSize
        self.imageViews = imageSet.getImages().map {
            let imageWrappingView = ImageUtils.getImageWrappingViewFor(element: $0, hostConfig: hostConfig, rootView: rootView, parentView: parentView, isImageSet: true, imageSetImageSize: imageSetImageSize)
            return imageWrappingView
        }
        super.init(frame: .zero)
        let layout = ACSCollectionViewAlignLayout()
        layout.sectionInset = NSEdgeInsets(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
        self.needsLayout = true
        collectionView.collectionViewLayout = layout
        collectionView.register(ACRCollectionViewItem.self, forItemWithIdentifier: ACRCollectionViewItem.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        let spacing = CGFloat(HostConfigUtils.getSpacing(imageSet.getSpacing(), with: hostConfig).floatValue)
        let frameWidth = self.bounds.width
        var totalHeight = CGFloat.zero
        var maxHeight = CGFloat.zero
        var rowWidth = CGFloat.zero
        
        for index in 0..<itemCount {
            if let imgItemProperties = imageViews[index].imageProperties {
                var explicitDimensions = NSSize.zero
                if imgItemProperties.hasExplicitDimensions && imgItemProperties.pixelWidth.isNormal && imgItemProperties.pixelHeight.isNormal {
                    explicitDimensions = NSSize(width: imgItemProperties.pixelWidth > self.bounds.width ? self.bounds.width : imgItemProperties.pixelWidth, height: imgItemProperties.pixelHeight)
                } else if imgItemProperties.hasExplicitDimensions && max(imgItemProperties.pixelWidth, imgItemProperties.pixelHeight).isNormal {
                    let maxValue = max(imgItemProperties.pixelWidth, imgItemProperties.pixelHeight)
                    explicitDimensions = NSSize(width: maxValue, height: maxValue)
                } else {
                    explicitDimensions = itemSize
                }
                let tempWidth = (rowWidth + explicitDimensions.width + spacing)
                if tempWidth <= frameWidth {
                    rowWidth += explicitDimensions.width + spacing
                    maxHeight = max(maxHeight, explicitDimensions.height)
                } else {
                    // add old
                    totalHeight += maxHeight + spacing
                    // start new
                    maxHeight = explicitDimensions.height
                    rowWidth = explicitDimensions.width + spacing
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
        let itemSpace = CGFloat(HostConfigUtils.getSpacing(self.imageSet.getSpacing(), with: hostConfig).floatValue)
        return itemSpace
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let itemSpace = CGFloat(HostConfigUtils.getSpacing(self.imageSet.getSpacing(), with: hostConfig).floatValue)
        return itemSpace
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard let itemProperties = imageViews[indexPath.item].imageProperties else { return itemSize }
        if itemProperties.hasExplicitDimensions {
            var size = NSSize.zero
            if !itemProperties.pixelWidth.isZero && !itemProperties.pixelHeight.isZero {
                size = NSSize(width: itemProperties.pixelWidth > self.bounds.width ? self.bounds.width : itemProperties.pixelWidth, height: itemProperties.pixelHeight)
                return size
            } else if itemProperties.pixelWidth.isZero || itemProperties.pixelHeight.isZero {
                let maxValue = max(itemProperties.pixelWidth, itemProperties.pixelHeight)
                size = NSSize(width: maxValue, height: maxValue)
                return size
            }
        }
        return itemSize
    }
}
