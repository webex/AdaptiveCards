import AdaptiveCards_bridge
import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "ImageSetItem")
    
    override func loadView() {
        view = itemView
    }
    
    private let itemView: NSView = {
        return NSView()
    }()
    
    func setupBounds(with imageView: ImageSetImageView) {
        imageView.removeFromSuperview()
        view.addSubview(imageView)
        imageView.frame = view.bounds
    }
}
