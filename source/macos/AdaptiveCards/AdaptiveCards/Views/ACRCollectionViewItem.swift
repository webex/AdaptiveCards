import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    var myImage: NSImage?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let imageView = NSImageView()
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = .clear
        view = imageView
    }
}
