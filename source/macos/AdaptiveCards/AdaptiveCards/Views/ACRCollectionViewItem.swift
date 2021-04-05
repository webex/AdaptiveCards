import AdaptiveCards_bridge
import Cocoa

class ACRCollectionViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "ImageSetItem")
    
    override func loadView() {
        view = itemView
    }
    
    private let itemView: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    func setupItem(with urlString: String, hostConfig: ACSHostConfig, imageSize: ACSImageSize) {
//        guard let url = URL(string: urlString) else {
//            logError("URL is invalid")
//            return
//        }
//        DispatchQueue.global().async {
//            guard let data = try? Data(contentsOf: url) else { return }
//            DispatchQueue.main.async {
//                guard let image = NSImage(data: data) else { return }
//                // Add
//                let imageRatio = ImageUtils.getAspectRatio(from: image.size)
//                var maxImageSize = ImageUtils.getImageSizeAsCGSize(imageSize: imageSize, width: 0, height: 0, with: hostConfig, explicitDimensions: false)
//                if imageRatio.height < 1 {
//                    maxImageSize.height *= imageRatio.height
//                }
//                image.size = maxImageSize
//                self.itemImageView.image = image
//            }
//        }
//    }
    
    func setupBounds(with imageView: ImageSetImageView, and imageSize: ACSImageSize, hostConfig: ACSHostConfig) {
        view.addSubview(imageView)
        view.invalidateIntrinsicContentSize()
    }
}
