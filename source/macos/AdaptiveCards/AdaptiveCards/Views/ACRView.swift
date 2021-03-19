import AdaptiveCards_bridge
import AppKit

protocol ACRViewDelegate: AnyObject {
    func acrView(_ view: ACRView, didSelectOpenURL url: String, button: NSButton)
}

protocol ACRViewResourceResolverDelegate: AnyObject {
    func resolve(_ adaptiveCard: ImageHandlerView, dimensionsForImageWith url: String) -> NSSize?
    func resolve(_ adaptiveCard: ImageHandlerView, requestImageFor url: String)
}

class ACRView: ACRColumnView {
    weak var delegate: ACRViewDelegate?
    weak var resolverDelegate: ACRViewResourceResolverDelegate?
    
    private (set) var targets: [TargetHandler] = []
    private var previousCardView = NSView()
    private (set) var imageViewMap: [String: [NSImageView]] = [:]

    init(style: ACSContainerStyle, hostConfig: ACSHostConfig) {
        super.init(style: style, parentStyle: nil, hostConfig: hostConfig, superview: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTarget(_ target: TargetHandler) {
        targets.append(target)
    }
    
    func getImageView(for url: String) -> NSImageView {
        let imageView: NSImageView
        if let dimensions = resolverDelegate?.resolve(self, dimensionsForImageWith: url) {
            let image = NSImage(size: dimensions)
            imageView = NSImageView(image: image)
        } else {
            imageView = NSImageView()
        }

        if imageViewMap[url] == nil { imageViewMap[url] = [] }
        imageViewMap[url]?.append(imageView)
        
        resolverDelegate?.resolve(self, requestImageFor: url)
        return imageView
    }
}

extension ACRView: TargetHandlerDelegate {
    func handleShowCardAction(button: NSButton, showCard: ACSAdaptiveCard) {
//        let showcard = AdaptiveCardRenderer.shared.renderAdaptiveCard(showCard, with: hostConfig, width: 335)
//
//        if button.state == .on {
//            showcard.layer?.backgroundColor = ColorUtils.hoverColorOnMouseEnter().cgColor
//            showcard.translatesAutoresizingMaskIntoConstraints = false
//
//            addArrangedSubview(showcard)
//            previousCardView = showcard
//        } else {
//            previousCardView.isHidden = true
//        }
    }
    
    func handleOpenURLAction(button: NSButton, urlString: String) {
        delegate?.acrView(self, didSelectOpenURL: urlString, button: button)
    }
}

extension ACRView: ImageHandlerView {
    func setImage(_ image: NSImage, for url: String) {
        guard let imageViews = imageViewMap[url] else {
            return
        }
        for imageView in imageViews {
            if imageView.image == nil {
                // update constraints only when image view does not contain an image
                ImageRenderer.shared.configUpdateForImage(image: image, imageView: imageView)
            }
            imageView.image = image
        }
    }
}
