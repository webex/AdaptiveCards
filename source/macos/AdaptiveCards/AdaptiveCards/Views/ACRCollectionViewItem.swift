import AdaptiveCards_bridge
import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "ImageSetItem")
    
    override func loadView() {
        view = NSView()
    }
    
    func setupBounds(with imageView: ACRImageWrappingView) {
        imageView.removeFromSuperview()
        view.addSubview(imageView)
        imageView.frame = view.bounds
    }
}
