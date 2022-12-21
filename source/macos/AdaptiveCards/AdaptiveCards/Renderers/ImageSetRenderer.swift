import AdaptiveCards_bridge
import AppKit

class ImageSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ImageSetRenderer()
 
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let imageSet = element as? ACSImageSet else {
            logError("Element is not of type ACSImageSet")
            return NSView()
        }
        let colView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: imageSet, hostConfig: hostConfig)
        colView.translatesAutoresizingMaskIntoConstraints = false
        if imageSet.getHeight() == .auto {
            // Set Hugging priority Setting a larger value to this priority indicates that we don’t want the view to grow larger than its content.
            colView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        } else {
            // Set Hugging priority Setting a lower value to this priority indicates that we want the view to grow larger than its content.
            colView.setContentHuggingPriority(kFillerViewLayoutConstraintPriority, for: .vertical)
        }
        return colView
    }
}
