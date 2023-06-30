import AdaptiveCards_bridge
import AppKit

class ColumnRenderer: BaseCardElementRendererProtocol {
    static let shared = ColumnRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let column = element as? ACSColumn else {
            logError("Element is not of type ACSColumn")
            return NSView()
        }
        
        let columnView = ACRColumnView(style: column.getStyle(), parentStyle: style, hostConfig: hostConfig, renderConfig: config, superview: parentView, needsPadding: column.getPadding())
        columnView.translatesAutoresizingMaskIntoConstraints = false
        if column.getSelectAction() != nil {
            rootView.accessibilityContext?.registerView(columnView)
        }
        columnView.setWidth(ColumnWidth(columnWidth: column.getWidth(), pixelWidth: column.getPixelWidth()))
        columnView.bleed = column.getBleed()
        if column.getVerticalContentAlignment() == .nil, let parentView = parentView as? ACRContentStackView {
            columnView.setVerticalContentAlignment(parentView.verticalContentAlignment)
        } else {
            columnView.setVerticalContentAlignment(column.getVerticalContentAlignment())
        }
		
        for (index, element) in column.getItems().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: element.getType())
            let view = renderer.render(element: element, with: hostConfig, style: style, rootView: rootView, parentView: columnView, inputs: [], config: config)
            columnView.configureColumnProperties(for: view)
            BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: element, parentView: columnView, rootView: rootView, style: style, hostConfig: hostConfig, config: config, isfirstElement: isFirstElement)
            BaseCardElementRenderer.shared.configBleed(for: view, with: hostConfig, element: element)
        }
        
        columnView.configureLayoutAndVisibility(minHeight: column.getMinHeight())
        
        if let backgroundImage = column.getBackgroundImage(), let url = backgroundImage.getUrl() {
            columnView.setupBackgroundImageProperties(backgroundImage)
            rootView.registerImageHandlingView(columnView.backgroundImageView, for: url)
        }
        
        columnView.setupSelectAction(column.getSelectAction(), rootView: rootView)
        columnView.setupSelectActionAccessibility(on: columnView, for: column.getSelectAction())
     
        return columnView
    }
}
