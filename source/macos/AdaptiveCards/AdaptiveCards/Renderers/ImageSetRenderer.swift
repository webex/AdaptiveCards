import AdaptiveCards_bridge
import AppKit

class ImageSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ImageSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let imageSet = element as? ACSImageSet else {
            logError("Element is not of type ACSImageSet")
            return NSView()
        }
        let imageSetView = ACRImageSetCollectionView()
        return imageSetView
    }
}
