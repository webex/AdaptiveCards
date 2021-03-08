import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    var itemView: ACRCollectionViewItemView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func loadView() {
//        let newFrame = NSRect(x: 0, y: 0, width: 50, height: 50)
        itemView = ACRCollectionViewItemView(frame: .zero)
        view = itemView ?? NSView()
    }
}
