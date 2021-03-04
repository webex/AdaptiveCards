import AdaptiveCards_bridge
import AppKit

class ACRCollectionViewItem: NSCollectionViewItem {
    @IBOutlet var contentView: NSView!
    @IBOutlet var labelView: NSTextField!
    
    init() {
        super.init(nibName: "ACRCollectionViewItem", bundle: Bundle(identifier: "com.test.test.AdaptiveCards"))
//        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
//            logError("Bundle is nil")
//            return
//        }
//        bundle.loadNibNamed("ACRCollectionViewItem", owner: self, topLevelObjects: nil)
//        setupViews()
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func setupViews() {
//        addSubview(contentView)
//    }

//    private func setupConstraints() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//    }
}
