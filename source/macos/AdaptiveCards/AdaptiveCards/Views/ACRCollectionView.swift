import AdaptiveCards_bridge
import AppKit

class ACRCollectionView: NSCollectionView {
    var imageSet: ACSImageSet?
    var imageSize: ACSImageSize?
    var hostConfig: ACSHostConfig?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame frameRect: NSRect, imageSet: ACSImageSet, hostConfig: ACSHostConfig) {
        super.init(frame: frameRect)
        
        let spacing: CGFloat = 2
        self.imageSet = imageSet
        self.hostConfig = hostConfig
        self.imageSize = imageSet.getImageSize()
        
        if imageSet.getImageSize() == .auto || imageSet.getImageSize() == .stretch || imageSet.getImageSize() == .none {
            self.imageSize = .medium
        }
        
        let layout = NSCollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        // TODO: Change minimumLineSpacing to 0 after adding images
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.estimatedItemSize = .zero
        layout.itemSize = ImageUtils.getImageSizeAsCGSize(imageSize: self.imageSize ?? .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false)
        collectionViewLayout = layout
        
        register(ACRCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"))
//        register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("MyItem"))
//        register(NSCollectionViewItem(), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"))
    }
    
    func newIntrinsicContentSize() -> CGSize {
        guard let layout = collectionViewLayout as? NSCollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
        let cellCounts = imageSet?.getImages().count ?? 0
        let newImageSize = layout.itemSize
        let spacing = layout.minimumInteritemSpacing
        let lineSpacing = layout.minimumLineSpacing
        let frameWidth = frame.size.width
        let imageSizeWithSpacing = newImageSize.width + spacing
        
        var numberOfItemsPerRow = Int(frameWidth / imageSizeWithSpacing)
        if CGFloat(numberOfItemsPerRow) * imageSizeWithSpacing + newImageSize.width <= frameWidth {
            numberOfItemsPerRow += 1
        }
        
        guard numberOfItemsPerRow > 0 else { return CGSize(width: 0, height: 0) }
        
        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
    
        return CGSize(width: frameWidth, height: (CGFloat(numberOfRows) * (newImageSize.height) + ((CGFloat(numberOfRows) - 1) * lineSpacing)))
    }
    
    override var intrinsicContentSize: NSSize {
        return newIntrinsicContentSize()
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let view = superview else { return }
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

// MARK: DataSource for CollectionView
class ACRCollectionViewDatasource: NSObject, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let collectionView = collectionView as? ACRCollectionView, let hostConfig = collectionView.hostConfig else { return NSCollectionViewItem() }
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"), for: indexPath)
        guard let collectionViewItem = item as? ACRCollectionViewItem else { return item }
        print(indexPath.item)
        let sample = "https://messagecardplayground.azurewebsites.net/assets/TxP_Flight.png"
        guard let imageSet = collectionView.imageSet else { return item }
        let imageArray = imageSet.getImages()
        let urlString = imageArray[indexPath.item].getUrl() ?? sample
        guard let url = URL(string: urlString) else { return item }
//        let image = NSImage(byReferencing: url)
//        let imageView = NSImageView(image: image)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageView = NSImageView()
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                guard let image = NSImage(data: data) else { return }
                image.size = ImageUtils.getImageSizeAsCGSize(imageSize: collectionView.imageSize ?? .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false)
                imageView.image = image
                imageView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
//        imageView.layer?.masksToBounds = true
//        imageView.setFrameSize(ImageUtils.getImageSizeAsCGSize(imageSize: collectionView.imageSize ?? .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false))
//        imageView.image?.size = ImageUtils.getImageSizeAsCGSize(imageSize: collectionView.imageSize ?? .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false)
//        let blueBox = NSView(frame: .zero)
//        blueBox.wantsLayer = true
//        blueBox.layer?.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
//        let newItem: ACRCollectionViewItem = collectionViewItem
//        newItem.view = imageView
//        collectionViewItem.myImage = image
//        collectionViewItem.view.addSubview(imageView)
//        collectionViewItem.imageView = imageView
//        collectionViewItem.view = blueBox
//        collectionViewItem.view = imageView
        collectionViewItem.view.addSubview(imageView)
        print(imageView)
//        collectionViewItem.myImage = image
        
//        collectionViewItem.view.layer?.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
//        guard var myImageView = collectionViewItem.view as? NSImageView else { return item }
        return collectionViewItem
//        return newItem
//        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"), for: indexPath)
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? ACRCollectionView, let newImageSet = collectionView.imageSet else { return 0 }
        return newImageSet.getImages().count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
}

extension ACRCollectionViewDatasource: NSCollectionViewDelegate { }

extension ACRCollectionViewDatasource: NSCollectionViewDelegateFlowLayout { }
