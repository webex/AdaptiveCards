import AdaptiveCards_bridge
import AppKit

class ACRCollectionView: NSScrollView {
    var dataSource: NSCollectionViewDataSource? {
        get { return collectionView.dataSource }
        set { collectionView.dataSource = newValue }
    }
    
    var delegate: NSCollectionViewDelegate? {
        get { return collectionView.delegate }
        set { collectionView.delegate = newValue }
    }
    
    private let imageSet: ACSImageSet
    private let imageSize: ACSImageSize
    private let hostConfig: ACSHostConfig
    
    private var itemSize: CGSize {
        switch imageSize {
        case .stretch, .none:
            return ImageUtils.getImageSizeAsCGSize(imageSize: .medium, with: hostConfig)
        case .auto:
            let mediumSize = ImageUtils.getImageSizeAsCGSize(imageSize: .medium, with: hostConfig)
            let itemWidth = min(mediumSize.width, bounds.width)
            return CGSize(width: itemWidth, height: itemWidth)
        default:
            return ImageUtils.getImageSizeAsCGSize(imageSize: imageSize, with: hostConfig)
        }
    }
    
    private lazy var collectionView: NSCollectionView = {
        let view = NSCollectionView()
        view.autoresizingMask = [.minXMargin, .minYMargin, .maxXMargin, .maxYMargin, .width, .height]
        view.itemPrototype = nil
        view.backgroundColors = [.clear]
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame frameRect: NSRect, imageSet: ACSImageSet, hostConfig: ACSHostConfig) {
        self.imageSet = imageSet
        self.hostConfig = hostConfig
        self.imageSize = imageSet.getImageSize()
        super.init(frame: frameRect)
        
        let spacing: CGFloat = 0
        let layout = NSCollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView.collectionViewLayout = layout
        collectionView.register(ACRCollectionViewItem.self, forItemWithIdentifier: ACRCollectionViewItem.identifier)
        
        autoresizingMask = [.minXMargin, .minYMargin, .maxXMargin, .maxYMargin, .width, .height]
        wantsLayer = true
        documentView = collectionView
        hasVerticalScroller = false
        hasHorizontalScroller = false
        scrollerStyle = .overlay
        autohidesScrollers = true
    }
    
    // Calculate ContentSize for CollectionView
    private func calculateContentSize() -> CGSize? {
        guard let layout = collectionView.collectionViewLayout as? NSCollectionViewFlowLayout, bounds.width > 0 else {
            return nil
        }
        
        let cellCounts = imageSet.getImages().count
        let spacing = layout.minimumInteritemSpacing
        let lineSpacing = layout.minimumLineSpacing
        let boundsWidth = bounds.width
        let itemSizeWithSpacing = itemSize.width + spacing
        
        var numberOfItemsPerRow = floor(boundsWidth / itemSizeWithSpacing)
        // if addtional image can be fit by removing spacing, do so
        if (numberOfItemsPerRow * itemSizeWithSpacing) + itemSize.width <= boundsWidth {
            numberOfItemsPerRow += 1
        }
        
        guard numberOfItemsPerRow > 0 else {
            return nil
        }
        
        let numberOfRows = ceil(CGFloat(cellCounts) / numberOfItemsPerRow)
        return CGSize(width: boundsWidth,
                      height: (numberOfRows * itemSize.height) + (numberOfRows - 1) * lineSpacing)
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
            guard let calcSize = calculateContentSize() else {
                return super.intrinsicContentSize
            }
            pContentSize = calcSize
            return calcSize
        }
        return contentSize
    }
    
    override func scrollWheel(with event: NSEvent) {
        nextResponder?.scrollWheel(with: event)
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let view = superview else { return }
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

// MARK: DataSource for CollectionView
class ACRCollectionViewDatasource: NSObject, NSCollectionViewDataSource {
    let imageViews: [ImageSetImageView]
    let images: [ACSImage]
    let hostConfig: ACSHostConfig
    let imageSize: ACSImageSize
    
    init(acsImages: [ACSImage], rootView: ACRView, size: ACSImageSize, hostConfig: ACSHostConfig) {
        self.images = acsImages
        self.hostConfig = hostConfig
        self.imageSize = size
        var imageViews: [ImageSetImageView] = []
        for image in images {
            let imageView = ImageSetImageView()
            imageView.hostConfig = hostConfig
            imageView.imageSize = size
            let url = image.getUrl() ?? ""
            rootView.registerImageHandlingView(imageView, for: url)
            imageViews.append(imageView)
        }
        self.imageViews = imageViews
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: ACRCollectionViewItem.identifier, for: indexPath) as? ACRCollectionViewItem else { return NSCollectionViewItem() }
        
        item.setupBounds(with: imageViews[indexPath.item])
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let resolvedSize: ACSImageSize
        let frameWidth = collectionView.bounds.width
        var itemSize: NSSize
        switch imageSize {
        case .stretch, .none:
            resolvedSize = .medium
        default:
            resolvedSize = imageSize
        }
        itemSize = ImageUtils.getImageSizeAsCGSize(imageSize: resolvedSize, width: 0, height: 0, with: hostConfig, explicitDimensions: false)
        if imageSize == .auto {
            let mediumImageSize = ImageUtils.getImageSizeAsCGSize(imageSize: .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false)
            let itemWidth = min(mediumImageSize.width, frameWidth)
            itemSize = NSSize(width: itemWidth, height: itemWidth)
        }
        return itemSize
    }
}

class ImageSetImageView: NSImageView, ImageHoldingView {
    var imageSize: ACSImageSize = .medium
    var hostConfig: ACSHostConfig?
    
    func setImage(_ image: NSImage) {
        guard let config = hostConfig else {
            self.image = image
            return
        }
        
        // If Image is smaller than cell, make image fit cell and maintain aspectRatio
        let imageRatio = ImageUtils.getAspectRatio(from: image.size)
        var maxImageSize = ImageUtils.getImageSizeAsCGSize(imageSize: imageSize, width: 0, height: 0, with: config, explicitDimensions: false)
        if imageRatio.height < 1 {
            maxImageSize.height *= imageRatio.height
        }
        image.size = maxImageSize
        self.image = image
    }
}

extension ACRCollectionViewDatasource: NSCollectionViewDelegate { }

extension ACRCollectionViewDatasource: NSCollectionViewDelegateFlowLayout { }
