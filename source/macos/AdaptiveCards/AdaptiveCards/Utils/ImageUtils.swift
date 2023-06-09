import AdaptiveCards_bridge
import AppKit
import CoreGraphics
import Foundation

class ImageUtils {
    static func getImageSizeAsCGSize(imageSize: ACSImageSize, with config: ACSHostConfig) -> CGSize {
        return getImageSizeAsCGSize(imageSize: imageSize, width: 0, height: 0, with: config, explicitDimensions: false)
    }
    
    static func getImageSizeAsCGSize(imageSize: ACSImageSize, width: CGFloat, height: CGFloat, with config: ACSHostConfig, explicitDimensions: Bool) -> CGSize {
        if explicitDimensions {
            let isAspectRatioNeeded = !(width > 0 && height > 0)
            var imageSizeAsCGSize = CGSize.zero
            
            if width > 0 {
                imageSizeAsCGSize.width = width
                if isAspectRatioNeeded {
                    imageSizeAsCGSize.height = width
                }
            }
            if height > 0 {
                imageSizeAsCGSize.height = height
                if isAspectRatioNeeded {
                    imageSizeAsCGSize.width = height
                }
            }
            return imageSizeAsCGSize
        }
        
        var sz: Float = 0.0
        switch imageSize {
        case ACSImageSize.large:
            if let size = config.getImageSizes()?.largeSize {
                sz = size.floatValue
            }
        case ACSImageSize.medium:
            if let size = config.getImageSizes()?.mediumSize {
                sz = size.floatValue
            }
        case ACSImageSize.small:
            if let size = config.getImageSizes()?.smallSize {
                sz = size.floatValue
            }
        case ACSImageSize.auto, ACSImageSize.stretch, ACSImageSize.none:
            return CGSize.zero
        default:
            return CGSize.zero
        }
        return CGSize(width: CGFloat(sz), height: CGFloat(sz))
    }
    
    static func getAspectRatio(from size: CGSize) -> CGSize {
        var heightToWidthRatio: CGFloat = 0.0
        var widthToHeightRatio: CGFloat = 0.0
        if size.width > 0 {
            heightToWidthRatio = size.height / size.width
        }

        if size.height > 0 {
            widthToHeightRatio = size.width / size.height
        }
        return CGSize(width: widthToHeightRatio, height: heightToWidthRatio)
    }
    
    static func configUpdateForImage(image: NSImage?, imageView: NSImageView) {
        guard let superView = imageView.superview as? ACRImageWrappingView, let imageSize = image?.absoluteSize else {
            logError("superView or image is nil")
            return
        }
        
        guard let imageProperties = superView.imageProperties else {
            logError("imageProperties is null")
            return
        }
        imageProperties.updateContentSize(size: imageSize)
        
        enum ImageViewConstraint: String {
            case imageHeight = "imageHeightValue"
            case imageWidth = "imageWidthValue"
            case imageAspect = "imageAspectValue"
            case imageAuto = "imageAutoValue"
        }
        let cgSize = imageProperties.contentSize
        let priority = self.getImageUILayoutPriority(imageView.superview)
        var constraints: [NSLayoutConstraint] = []
        
        // This constraint need for image size [small, medium, large]
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: cgSize.width))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: cgSize.height))
        constraints[0].priority = priority
        constraints[0].identifier = ImageViewConstraint.imageWidth.rawValue
        constraints[1].priority = priority
        constraints[1].identifier = ImageViewConstraint.imageHeight.rawValue
        
        // This constraint fit image in container with a aspect ratio
        let aspectRatio = ACRImageProperties.convertToAspectRatio(cgSize)
        if aspectRatio.heightToWidth != 0 {
            constraints.append(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: aspectRatio.heightToWidth, constant: 0))
        } else if aspectRatio.widthToHeight != 0 {
            constraints.append(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: aspectRatio.widthToHeight, constant: 0))
        }
        // Give the aspect ratio constraint a two-digit priority boost for first fulfilment. Priorities are calculated when the window loads the view. Otherwise, a constraint conflict will occur.
        constraints[2].priority = priority + 2
        constraints[2].identifier = ImageViewConstraint.imageAspect.rawValue
        
        if imageProperties.acsImageSize == .auto {
            constraints.append(imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageProperties.contentSize.width))
            constraints[3].identifier = ImageViewConstraint.imageAuto.rawValue
        }
        
        // remove old constraint to avoid dublicates
        for constraint in imageView.constraints {
            if ImageViewConstraint(rawValue: constraint.identifier ?? "") != nil {
                NSLayoutConstraint.deactivate([constraint])
            }
        }
        NSLayoutConstraint.activate(constraints)
        superView.update(imageProperties: imageProperties)
    }
    
    // Prioritize layout based on content hugging.
    static func getImageUILayoutPriority(_ wrapView: NSView?) -> NSLayoutConstraint.Priority {
        if let wrapView = wrapView {
            let priority = wrapView.contentHuggingPriority(for: .horizontal)
            return (priority > .init(249)) ? .defaultHigh : priority
        }
        return .defaultHigh
    }
    
    // return ACRImageWrappingView
    static func getImageWrappingViewFor(element: ACSImage, hostConfig: ACSHostConfig, rootView: ACRView, parentView: NSView, isImageSet: Bool = false, imageSetImageSize: ACSImageSize = .none) -> ACRImageWrappingView {
        let imageProperties = ACRImageProperties(element: element, config: hostConfig, parentView: parentView, isImageSet: isImageSet, imageSetImageSize: imageSetImageSize)
        guard let url = element.getUrl() else {
            logError("URL is not available")
            return ACRImageWrappingView(imageProperties: imageProperties, imageView: ImageView())
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
                    
        // Setting up ImageView based on Image Properties
        imageView.wantsLayer = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer?.masksToBounds = true
        
        // Setting up content holder view
        let wrappingView = ACRImageWrappingView(imageProperties: imageProperties, imageView: imageView)
        wrappingView.translatesAutoresizingMaskIntoConstraints = false
        wrappingView.isImageSet = isImageSet
        // Background color attribute
        if let backgroundColor = element.getBackgroundColor(), !backgroundColor.isEmpty {
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
            self.configUpdateForImage(image: imageView.image, imageView: imageView)
        }
        
        if element.getStyle() == .person {
            wrappingView.isPersonStyle = true
        }
        if let id = element.getId(), !id.isEmpty, isImageSet {
            wrappingView.identifier = NSUserInterfaceItemIdentifier(id)
        }
        if element.getSelectAction() != nil {
            rootView.accessibilityContext?.registerView(wrappingView)
        }
        wrappingView.setupSelectAction(element.getSelectAction(), rootView: rootView)
        wrappingView.setupSelectActionAccessibility(on: wrappingView, for: element.getSelectAction())
        return wrappingView
    }
}
