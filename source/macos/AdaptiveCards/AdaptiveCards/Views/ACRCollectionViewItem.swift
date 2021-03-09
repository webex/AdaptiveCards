import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    var myImage: NSImage?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
//        let redBox = NSView(frame: .zero)
//        redBox.wantsLayer = true
//        redBox.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
//        view = redBox
        let imageView = NSImageView()
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        imageView.image = myImage
        view = imageView
//        view = NSView()
//        view.addSubview(imageView)
    }
}
// guard let newImageView = self.myImageView else { view = NSView()
//    return }
// newImageView.wantsLayer = true
// newImageView.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
// view = newImageView
