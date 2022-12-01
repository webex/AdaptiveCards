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
        imageWrapView.frame = view.bounds
        view.addSubview(imageWrapView)
    }
}
