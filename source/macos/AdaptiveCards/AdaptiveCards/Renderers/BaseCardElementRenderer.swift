import AdaptiveCards_bridge
import AppKit

let kFitViewHorizontalLayoutConstraintPriority = NSLayoutConstraint.Priority.defaultLow - 1

class BaseCardElementRenderer {
    static let shared = BaseCardElementRenderer()
    
    func updateLayoutForSeparatorAndAlignment(view: NSView, element: ACSBaseCardElement, parentView: ACRContentStackView, rootView: ACRView, style: ACSContainerStyle, hostConfig: ACSHostConfig, config: RenderConfig, isfirstElement: Bool) {
        var separator: SpacingView?
        if !isfirstElement {
            // For seperator and spacing
            separator = SpacingView.renderSpacer(elem: element, forSuperView: parentView, withHostConfig: hostConfig)
        }
        
        if let collectionElement = element as? ACSStyledCollectionElement {
            if let columnView = view as? ACRColumnView, let backgroundImage = collectionElement.getBackgroundImage(), let url = backgroundImage.getUrl() {
                columnView.setupBackgroundImageProperties(backgroundImage)
                rootView.registerImageHandlingView(columnView.backgroundImageView, for: url)
            }
            if let containerView = view as? ACRContainerView, let backgroundImage = collectionElement.getBackgroundImage(), let url = backgroundImage.getUrl() {
                containerView.setupBackgroundImageProperties(backgroundImage)
                rootView.registerImageHandlingView(containerView.backgroundImageView, for: url)
            }
        }
        
        if let id = element.getId(), !id.isEmpty {
            view.identifier = NSUserInterfaceItemIdentifier(id)
        }
        
        if let inputElement = element as? ACSBaseInputElement {
            parentView.configureInputElements(element: inputElement, view: view)
        } else {
            // When the element is ACSBaseInputElement, this step occurs inside configureInputElements directly
            parentView.addArrangedSubview(view)
        }
        
        parentView.updateLayoutAndVisibilityOfRenderedView(view, acoElement: element, separator: separator, rootView: rootView)
        
        // Keep single every view horizontal fit inside the nsstackview
        /*
         B = StackView
         A = inside subview
         B+------------------------------+
          | A+------------------------+  |
          |  |       H:249            |  |
          |  |       V:250            |  |
          |  +------------------------+  |
          +------------------------------+
         
         B+------------------------------+
          | A+---------+                 |
          |  | H:250   |                 |
          |  | V:250   |                 |
          |  +---------+                 |
          +------------------------------+
         */
        view.setContentHuggingPriority(kFitViewHorizontalLayoutConstraintPriority, for: .horizontal)
    }
    
    func configBleed(for view: NSView, with hostConfig: ACSHostConfig, element: ACSBaseCardElement) {
        guard let collectionElem = element as? ACSStyledCollectionElement, collectionElem.getBleed() else { return }
        guard let collectionView = view as? ACRContentStackView else {
            logError("Container is not type of ACRContentStackView")
            return
        }
        guard collectionElem.getPadding(), collectionElem.getCanBleed() else { return }
        
        let padding = CGFloat(truncating: hostConfig.getSpacing()?.paddingSpacing ?? 0)
        let bleedDirectionValues = ACRBleedDirection(rawValue: collectionElem.getBleedDirection().rawValue).getBleedValues()
        
        // stackview constraint setup for bleed
        collectionView.setStackViewConstraint(direction: bleedDirectionValues)
        
        // bleed view setup
        collectionView.setBleedViewConstraint(direction: bleedDirectionValues, with: padding)
        
        // background image setup
        if collectionElem.getBackgroundImage() != nil {
            if let columnView = collectionView as? ACRColumnView {
                columnView.bleedBackgroundImage(direction: bleedDirectionValues, with: padding)
            }
            if let containerView = collectionView as? ACRContainerView {
                containerView.bleedBackgroundImage(direction: bleedDirectionValues, with: padding)
            }
        }
    }
}
