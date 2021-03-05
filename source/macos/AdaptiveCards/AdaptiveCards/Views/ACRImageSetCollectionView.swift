import AdaptiveCards_bridge
import AppKit

class ACRImageSetCollectionView: NSView {
//    @IBOutlet var contentView: NSView!
//    @IBOutlet var scrollView: NSScrollView!
//    @IBOutlet var collectionView: NSCollectionView!
    
    let rIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ACRCollectionViewItem")
    
    private lazy var collectionView: NSCollectionView = {
        let view = NSCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.register("ACRCollectionViewItem.xib", forItemWithIdentifier: rIdentifier)
        view.minItemSize = NSSize(width: 100, height: 100)
        view.collectionViewLayout = NSCollectionViewFlowLayout()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    init() {
        super.init(frame: .zero)
//        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
//            logError("Bundle is nil")
//            return
//        }
//        bundle.loadNibNamed("ACRImageSetCollectionView", owner: self, topLevelObjects: nil)
//        let item = NSNib(nibNamed: "ACRCollectionViewItem", bundle: Bundle(identifier: "com.test.test.AdaptiveCards"))
//        collectionView.register(item, forItemWithIdentifier: rIdentifier)
//
//        collectionView.delegate = self
//        collectionView.dataSource = self

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.register(ACRCollectionViewItem.self, forItemWithIdentifier: ACRCollectionViewItem.reuseIdentifier)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 20
//    }
    
//    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
//        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ACRCollectionViewItem"), for: indexPath)
//
//        print("Hi")
//
//        return item
//    }
    
    private func setupViews() {
        addSubview(collectionView)
        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
            logError("Bundle is nil")
            return
        }
//        bundle.loadNibNamed("ACRImageSetCollectionView", owner: self, topLevelObjects: nil)
        let item = NSNib(nibNamed: "ACRCollectionViewItem", bundle: Bundle(identifier: "com.test.test.AdaptiveCards"))
        collectionView.register(item, forItemWithIdentifier: rIdentifier)
    }

    private func setupConstraints() {
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
extension ACRImageSetCollectionView: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: rIdentifier, for: indexPath)
        item.textField?.stringValue = "\(indexPath.section), \(indexPath.item)"
        return item
//        let item = ACRCollectionViewItem()
//        item.sourceItemView?.wantsLayer = true
//        item.sourceItemView?.layer?.backgroundColor = .black
//        return item
    }
}

extension ACRImageSetCollectionView: NSCollectionViewDelegate { }
