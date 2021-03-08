import AdaptiveCards_bridge
import AppKit

class ACRCollectionView: NSCollectionView {
    let spacing: CGFloat = 5
    let numberOfItemsPerRow: CGFloat = 8
    var imageSet: ACSImageSet?
    var imageSize: ACSImageSize?
    var hostConfig: ACSHostConfig?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let layout = NSCollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        let imageConfig = hostConfig?.getImageSet()
        layout.itemSize = CGSize(width: 100, height: 100)

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
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        let imageConfig = hostConfig.getImageSet()
//        layout.itemSize = CGSize(width: 100, height: 100)

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
//    func newIntrinsicContentSize() -> CGSize {
//        let cellCounts = imageSet?.getImages().count ?? 0
//        let imageSize = self.collectionViewLayout.item
//        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
//        return CGSize(width: self.bounds.width, height: (CGFloat(numberOfRows) * (objectSize.height) + ((CGFloat(numberOfRows) - 1) * spacing)))
//    }
    
//    override var intrinsicContentSize: NSSize {
//        return NSSize(width: 200, height: 200)
//        return newIntrinsicContentSize()
//    }
        
//        return self.collectionViewLayout?.collectionViewContentSize ?? NSSize(width: 100, height: 100)
//    }
    
//    let obj = ACRCollectionViewItem().collectionView?.collectionViewLayout?.collectionViewContentSize
//    override func reloadData() {
//        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//    }
}

// class CustomClass: NSView {
//    var collectionView = ACRCollectionView()
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        addViews()
//        addConstraints()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func viewDidMoveToSuperview() {
//        print(collectionView.collectionViewLayout?.collectionViewContentSize)
//    }
//    func addViews() {
//        addSubview(collectionView)
//    }
//    func addConstraints() {
//        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//    }
// }

class ACRCollectionViewDatasource: NSObject, NSCollectionViewDataSource {
    var collectionView: ACRCollectionView?
    let spacing = ACRCollectionView().spacing
    var newWidth: CGFloat?
    let numberOfItemsPerRow = ACRCollectionView().numberOfItemsPerRow
//    let imageSet
    func setupView(_ colView: ACRCollectionView) {
        collectionView = colView
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"), for: indexPath)
        
//        let cell = collectionView.item(at: indexPath) as! MyItem
//        cell.itemView?.label.string = "\(indexPath.section), \(indexPath.item)"
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let newImageSet = self.collectionView?.imageSet else { return 0 }
        return newImageSet.getImages().count
        
//        return 5
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerRow
            newWidth = width
            guard let height = ACRCollectionViewItemView().box?.bounds.size.height else { return CGSize(width: 0, height: 0) }
            return CGSize(width: width, height: height)
        } else {
            newWidth = 50
            return CGSize(width: 0, height: 0)
        }
    }
    
    func getHeightOfView() -> CGFloat {
        let height: CGFloat
//        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
        guard let collection = self.collectionView else { return 0 }
        let cellCounts = collection.numberOfItems(inSection: 0)
//        let heightOfItem = collection.bounds.height
//        guard let heightOfItem = newWidth else { return 0 }
        guard let heightOfItem = ACRCollectionViewItemView().box?.bounds.size.height else { return 0 }
        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
        height = (CGFloat(numberOfRows) * (heightOfItem) + ((CGFloat(numberOfRows) - 1) * spacing))
        return height
    }
}

extension ACRCollectionViewDatasource: NSCollectionViewDelegate { }

extension ACRCollectionViewDatasource: NSCollectionViewDelegateFlowLayout {
    private func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        return NSSize(width: 40, height: 30)
    }
}
