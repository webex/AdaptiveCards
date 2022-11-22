import AdaptiveCards_bridge
import AppKit

class ImageRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ImageRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let imageElement = element as? ACSImage else {
            logError("Element is not of type ACSImage")
            return NSView()
        }
        let imageWrappingView = ImageUtils.getImageWrappingViewFor(element: imageElement, hostConfig: hostConfig, rootView: rootView, parentView: parentView)
        return imageWrappingView
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
            ImageUtils.configUpdateForImage(image: image, imageView: self)
        }
        self.image = image
    }
}
