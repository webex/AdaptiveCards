import AdaptiveCards_bridge
import AppKit

class ACRCollectionView: NSCollectionView {
    let spacing: CGFloat = 0
    var numberOfItemsPerRow: CGFloat = 8
    var imageSet: ACSImageSet?
    var imageSize: ACSImageSize?
    var hostConfig: ACSHostConfig?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let layout = NSCollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0

        collectionViewLayout = layout
        register(ACRCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"))
//        self.invalidateIntrinsicContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame frameRect: NSRect, imageSet: ACSImageSet, hostConfig: ACSHostConfig) {
        super.init(frame: frameRect)
        self.imageSet = imageSet
        self.hostConfig = hostConfig
        self.imageSize = imageSet.getImageSize()
        if imageSet.getImageSize() == .auto || imageSet.getImageSize() == .stretch || imageSet.getImageSize() == .none {
            self.imageSize = .medium
        }
        let layout = NSCollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = ImageUtils.getImageSizeAsCGSize(imageSize: self.imageSize ?? .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false)

        collectionViewLayout = layout
        register(ACRCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"))
    }
    
    func setupVaribles(imageSet: ACSImageSet, hostConfig: ACSHostConfig) {
        self.imageSet = imageSet
        self.hostConfig = hostConfig
        self.imageSize = imageSet.getImageSize()
        if imageSet.getImageSize() == .auto || imageSet.getImageSize() == .stretch || imageSet.getImageSize() == .none {
            self.imageSize = .medium
        }
    }
//    let item = ACRCollectionViewItemView().frame.size
    func newIntrinsicContentSize() -> CGSize {
        let cellCounts = imageSet?.getImages().count ?? 0
        guard let layout = collectionViewLayout as? NSCollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
        let newImageSize = layout.itemSize
        let spacing = layout.minimumInteritemSpacing
        let lineSpacing = layout.minimumLineSpacing
        
        let frameWidth = frame.size.width
        let imageSizeWithSpacing = newImageSize.width + spacing
        
        print("FRAME : ", frame, "image size", newImageSize)
        
        numberOfItemsPerRow = frameWidth / imageSizeWithSpacing
        if numberOfItemsPerRow * imageSizeWithSpacing + newImageSize.width <= frameWidth {
            numberOfItemsPerRow += 1
        }
        
        guard numberOfItemsPerRow > 0 else { return CGSize(width: 0, height: 0) }
        
        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
    
        return CGSize(width: self.frame.size.width, height: (CGFloat(numberOfRows) * (newImageSize.height) + ((CGFloat(numberOfRows) - 1) * lineSpacing)))
    }
    
    override var intrinsicContentSize: NSSize {
        return newIntrinsicContentSize()
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let view = superview else { return }
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
        
//        return self.collectionViewLayout?.collectionViewContentSize ?? NSSize(width: 100, height: 100)
//    }
    
//    let obj = ACRCollectionViewItem().collectionView?.collectionViewLayout?.collectionViewContentSize
//    override func reloadData() {
//        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//    }
}

class ACRCollectionViewDatasource: NSObject, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let collectionView = collectionView as? ACRCollectionView else { return NSCollectionViewItem() }
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"), for: indexPath)
        guard let collectionViewItem = item as? ACRCollectionViewItem else { return item }
//        guard let layout = collectionView.collectionViewLayout as? NSCollectionViewFlowLayout else { return item }
//        collectionViewItem.itemView?.bounds.size = layout.size
//        let cell = collectionView.item(at: indexPath) as! MyItem
//        cell.itemView?.label.string = "\(indexPath.section), \(indexPath.item)"
        guard let hostConfig = collectionView.hostConfig else { return item }
        collectionViewItem.itemView?.box?.setFrameSize(ImageUtils.getImageSizeAsCGSize(imageSize: collectionView.imageSize ?? .medium, width: 0, height: 0, with: hostConfig, explicitDimensions: false))
        return collectionViewItem
//        let identifier: NSString = "cellid"
//        let setElem = collectionView.imageSet?.getImages()
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? ACRCollectionView, let newImageSet = collectionView.imageSet else { return 0 }
        return newImageSet.getImages().count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
//        if let collection = self.collectionView {
//            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerRow
//            newWidth = width
//            guard let height = ACRCollectionViewItemView().box?.bounds.size.height else { return CGSize(width: 0, height: 0) }
//            return CGSize(width: width, height: height)
//        } else {
//            newWidth = 50
//            return CGSize(width: 0, height: 0)
//        }
//    }
    
//    func getHeightOfView() -> CGFloat {
//        let height: CGFloat
//        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
//        guard let collection = self.collectionView else { return 0 }
//        let cellCounts = collection.numberOfItems(inSection: 0)
//        let heightOfItem = collection.bounds.height
//        guard let heightOfItem = newWidth else { return 0 }
//        guard let heightOfItem = ACRCollectionViewItemView().box?.bounds.size.height else { return 0 }
//        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
//        height = (CGFloat(numberOfRows) * (heightOfItem) + ((CGFloat(numberOfRows) - 1) * spacing))
//        return height
//    }
}

extension ACRCollectionViewDatasource: NSCollectionViewDelegate { }

<<<<<<< HEAD
extension ACRCollectionViewDatasource: NSCollectionViewDelegateFlowLayout { }
=======
extension ACRCollectionViewDatasource: NSCollectionViewDelegateFlowLayout {
    private func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        return NSSize(width: 40, height: 30)
    }
}
>>>>>>> f4cfcbfa15fd9be7b771fc01c8361f77cbf2818b
