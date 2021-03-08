import AppKit

class ACRCollectionView: NSCollectionView {
    let spacing: CGFloat = 5
    let numberOfItemsPerRow: CGFloat = 8
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        let layout = NSCollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionViewLayout = layout
        register(ACRCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"))
//        self.invalidateIntrinsicContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let item = ACRCollectionViewItemView().frame.size
//    func newIntrinsicContentSize() -> CGSize {
//        let cellCounts = numberOfItems(inSection: 0)
//        let objectSize = CGSize(width: 50, height: 50)
//        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
//        return CGSize(width: self.bounds.width, height: (CGFloat(numberOfRows) * (objectSize.height) + ((CGFloat(numberOfRows) - 1) * spacing)))
//    }
    
//    override var intrinsicContentSize: NSSize {
//        return newIntrinsicContentSize()
        
//        return self.collectionViewLayout?.collectionViewContentSize ?? NSSize(width: 100, height: 100)
//    }
    
//    let obj = ACRCollectionViewItem().collectionView?.collectionViewLayout?.collectionViewContentSize
//    override func reloadData() {
//        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//    }
}

 class CustomClass: NSView {
    var collectionView = ACRCollectionView()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addViews()
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidMoveToSuperview() {
        print(collectionView.collectionViewLayout?.collectionViewContentSize)
    }
    func addViews() {
        addSubview(collectionView)
    }
    func addConstraints() {
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
 }

class ACRCollectionViewDatasource: NSObject, NSCollectionViewDataSource {
    var collectionView: NSCollectionView?
    let spacing = ACRCollectionView().spacing
    var newWidth: CGFloat?
    let numberOfItemsPerRow = ACRCollectionView().numberOfItemsPerRow
    func setupView(_ colView: NSCollectionView) {
        collectionView = colView
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyItem"), for: indexPath)
        
//        let cell = collectionView.item(at: indexPath) as! MyItem
//        cell.itemView?.label.string = "\(indexPath.section), \(indexPath.item)"
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
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
