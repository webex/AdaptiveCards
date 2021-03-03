import AdaptiveCards_bridge
import AppKit

class ImageRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ImageRenderer()
    let sample = "https://messagecardplayground.azurewebsites.net/assets/TxP_Flight.png"
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let imageElement = element as? ACSImage else {
            logError("Element is not of type ACSImage")
            return NSView()
        }
        
        // Fetching images from remote URL for testing purposes (Blocks main thread)
        // This will be removed and changed to Resource Resolver or similar mechanism to resolve content
        // swiftlint:disable force_cast
        let url = URL(string: imageElement.getUrl() ?? self.sample)
        let image = NSImage(byReferencing: url as! URL)
        // swiftlint:enable force_cast
                
        // Setting up image Properties
        let imageProperties = ACRImageProperties(element: imageElement, config: hostConfig, image: image, parentView: parentView)
        let cgsize = imageProperties.contentSize

        // Setting up ImageView based on Image Properties
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: cgsize.width, height: cgsize.height))
        if imageProperties.isAspectRatioNeeded {
            // when either width or height px is available
            // this will provide content aspect fill scaling
            imageView.imageScaling = .scaleProportionallyUpOrDown
        } else {
            // content aspect fit behaviour
            imageView.imageScaling = .scaleAxesIndependently
        }
        imageView.image = image
        
        guard let parent = rootView as? ACRContentStackView else {
            logError("Parent is not of type ACRContentStackView")
            return NSView()
        }
    
        // Setting up content holder view
        let wrappingView = ACRContentHoldingView(imageProperties: imageProperties, imageView: imageView, viewgroup: parent)
    
        // Background color attribute
        if imageElement.getBackgroundColor() != nil {
            imageView.wantsLayer = true
            if let color = ColorUtils.color(from: imageElement.getBackgroundColor() ?? "") {
                imageView.layer?.backgroundColor = ColorUtils.getCGColor(from: color)
            }
        }
    
        // Person style effect
        if imageElement.getStyle() == ACSImageStyle.person {
            let radius: CGFloat = image.size.width / 2.0
            imageView.layer?.cornerRadius = radius
            imageView.layer?.masksToBounds = true
        }
        
        parent.addArrangedSubview(wrappingView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        wrappingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setting up constraints for alignment
        // Need a better way than using anchors
        switch imageProperties.acsHorizontalAlignment {
        case .center:
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        case .left:
            imageView.leadingAnchor.constraint(equalTo: wrappingView.leadingAnchor).isActive = true
        case .right:
            imageView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        default:
            imageView.leadingAnchor.constraint(equalTo: wrappingView.leadingAnchor).isActive = true
        }
        
//        // wrappingView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
//        if imageProperties.acsImageSize == ACSImageSize.stretch {
//            parent.widthAnchor.constraint(equalTo: wrappingView.widthAnchor).isActive = true
//            imageView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
//        } else {
//        }
//
//         imageView.topAnchor.constraint(equalTo: wrappingView.topAnchor).isActive = true
        
        return wrappingView
    }
}
