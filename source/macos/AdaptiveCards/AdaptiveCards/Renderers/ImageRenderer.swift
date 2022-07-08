import AdaptiveCards_bridge
import AppKit

class ImageRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ImageRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let imageElement = element as? ACSImage else {
            logError("Element is not of type ACSImage")
            return NSView()
        }
        
        guard let url = imageElement.getUrl() else {
            logError("URL is not available")
            return NSView()
        }
        // ImageView
        let imageView: ImageView
        
        if let dimensions = rootView.getImageDimensions(for: url) {
            let image = NSImage(size: dimensions)
            imageView = ImageView(image: image)
        } else {
            imageView = ImageView()
        }
        
        rootView.registerImageHandlingView(imageView, for: url)
        
        let imageProperties = ACRImageProperties(element: imageElement, config: hostConfig, parentView: parentView)
        
        // Setting up ImageView based on Image Properties
        imageView.wantsLayer = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer?.masksToBounds = true
        
        // Setting up content holder view
        let wrappingView = ACRImageWrappingView(imageProperties: imageProperties, imageView: imageView)
        wrappingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Background color attribute
        if let backgroundColor = imageElement.getBackgroundColor(), !backgroundColor.isEmpty {
            imageView.wantsLayer = true
            if let color = ColorUtils.color(from: backgroundColor) {
                imageView.layer?.backgroundColor = color.cgColor
            }
        }
        
        switch imageProperties.acsHorizontalAlignment {
        case .center:
            imageView.centerXAnchor.constraint(equalTo: wrappingView.centerXAnchor).isActive = true
        case .right:
            imageView.trailingAnchor.constraint(equalTo: wrappingView.trailingAnchor).isActive = true
        case .left:
            imageView.leadingAnchor.constraint(equalTo: wrappingView.leadingAnchor).isActive = true
        default:
            imageView.leadingAnchor.constraint(equalTo: wrappingView.leadingAnchor).isActive = true
        }
        
        wrappingView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        wrappingView.widthAnchor.constraint(greaterThanOrEqualTo: imageView.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: wrappingView.topAnchor).isActive = true
        
        if imageProperties.isAspectRatioNeeded {
            // when either width or height px is available
            // this will provide content aspect fill scaling
            imageView.imageScaling = .scaleProportionallyUpOrDown
        } else {
            // content aspect fit behaviour
            imageView.imageScaling = .scaleAxesIndependently
        }
        
        let imagePriority = self.getImageUILayoutPriority(wrappingView)
        if imageProperties.acsImageSize != ACSImageSize.stretch {
            imageView.setContentHuggingPriority(imagePriority, for: .horizontal)
            imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            imageView.setContentCompressionResistancePriority(imagePriority, for: .horizontal)
            imageView.setContentCompressionResistancePriority(imagePriority, for: .vertical)
        }
        
        if imageView.image != nil {
            configUpdateForImage(image: imageView.image, imageView: imageView)
        }
        
        if imageElement.getStyle() == .person {
            wrappingView.isPersonStyle = true
        }
        
        wrappingView.setupSelectAction(imageElement.getSelectAction(), rootView: rootView)
        wrappingView.setupSelectActionAccessibility(on: wrappingView, for: imageElement.getSelectAction())
        
        return wrappingView
    }
    
    func configUpdateForImage(image: NSImage?, imageView: NSImageView) {
        guard let superView = imageView.superview as? ACRImageWrappingView, let imageSize = image?.absoluteSize else {
            logError("superView or image is nil")
            return
        }
        
        guard let imageProperties = superView.imageProperties else {
            logError("imageProperties is null")
            return
        }
        
        imageProperties.updateContentSize(size: imageSize)
        
        let cgSize = imageProperties.contentSize
        let priority = self.getImageUILayoutPriority(imageView.superview)
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: cgSize.width))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: cgSize.height))
        constraints[0].priority = priority
        constraints[1].priority = priority
        
        let aspectRatio = ACRImageProperties.convertToAspectRatio(cgSize)
        
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: aspectRatio.heightToWidth, constant: 0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: aspectRatio.widthToHeight, constant: 0))
        // Give the aspect ratio constraint a two-digit priority boost for first fulfilment. Priorities are calculated when the window loads the view. Otherwise, a constraint conflict will occur.
        constraints[2].priority = priority + 2
        constraints[3].priority = priority + 2
        
        if imageProperties.acsImageSize == .auto {
            constraints.append(imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageProperties.contentSize.width))
        }
        
        NSLayoutConstraint.activate(constraints)
        superView.update(imageProperties: imageProperties)
    }
    
    // Prioritize layout based on content hugging.
    func getImageUILayoutPriority(_ wrapView: NSView?) -> NSLayoutConstraint.Priority {
        if let wrapView = wrapView {
            let priority = wrapView.contentHuggingPriority(for: .horizontal)
            return (priority > .init(249)) ? .defaultHigh : priority
        }
        return .defaultHigh
    }
}

class ImageView: NSImageView, ImageHoldingView {
    override var intrinsicContentSize: NSSize {
        guard let image = image else {
            return .zero
        }
        return image.absoluteSize
    }
    func setImage(_ image: NSImage) {
        if self.image == nil {
            // update constraints only when image view does not contain an image
            ImageRenderer.shared.configUpdateForImage(image: image, imageView: self)
        }
        self.image = image
    }
}
