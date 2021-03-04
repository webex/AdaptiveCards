import AdaptiveCards_bridge
import AppKit

class ACRImageSetCollectionView: NSView, NSCollectionViewDelegate, NSCollectionViewDataSource {
    @IBOutlet var contentView: NSView!
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var collectionView: NSCollectionView!
    
    init() {
        super.init(frame: .zero)
        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
            logError("Bundle is nil")
            return
        }
        bundle.loadNibNamed("ACRImageSetCollectionView", owner: self, topLevelObjects: nil)
        let item = NSNib(nibNamed: "ACRCollectionViewItem", bundle: Bundle(identifier: "com.test.test.AdaptiveCards"))
        collectionView.register(item, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ACRCollectionViewItem"))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ACRCollectionViewItem"), for: indexPath)
        
        print("Hi")
        
        return item
    }
    
    private func setupViews() {
        addSubview(contentView)
    }

    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
