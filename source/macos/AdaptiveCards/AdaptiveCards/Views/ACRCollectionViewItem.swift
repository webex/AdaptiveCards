import AdaptiveCards_bridge
import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "ImageSetItem")
    var imageWrapView: ACRImageWrappingView?
    override func loadView() {
        view = NSView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageWrapView?.removeFromSuperview()
    }
    
    func setupBounds(with imageView: ACRImageWrappingView) {
        imageWrapView = imageView
        guard let imageWrapView = imageWrapView else { return }
        // Note: We've given 8px padding for the focus ring, so the centre must shift half the width.
        imageView.frame = view.bounds.offsetBy(dx: 4, dy: 4)
        view.addSubview(imageWrapView)
    }
}
