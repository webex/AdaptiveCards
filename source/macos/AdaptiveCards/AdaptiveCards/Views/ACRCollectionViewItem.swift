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
        // Note: We've given 8px padding for the focus ring, so the centre must shift half the width.
        imageView.frame = view.bounds.offsetBy(dx: 4, dy: 4)
    }
}
