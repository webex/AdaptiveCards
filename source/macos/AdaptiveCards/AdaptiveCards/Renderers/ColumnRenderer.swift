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
        columnView.setWidth(ColumnWidth(columnWidth: column.getWidth(), pixelWidth: column.getPixelWidth()))
        columnView.bleed = column.getBleed()
        
        var topSpacingView: SpacingView?
        if column.getVerticalContentAlignment() == .center || column.getVerticalContentAlignment() == .bottom {
            let view = SpacingView()
            columnView.addArrangedSubview(view)
            topSpacingView = view
        }
        
        for (index, element) in column.getItems().enumerated() {
            let isFirstElement = index == 0
            let renderer = RendererManager.shared.renderer(for: element.getType())
            let view = renderer.render(element: element, with: hostConfig, style: style, rootView: rootView, parentView: columnView, inputs: [], config: config)
            columnView.configureColumnProperties(for: view)
            BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: element, parentView: columnView, rootView: rootView, style: style, hostConfig: hostConfig, config: config, isfirstElement: isFirstElement)
            BaseCardElementRenderer.shared.configBleed(collectionView: view, parentView: columnView, with: hostConfig, element: element, parentElement: column)
        }
        
        columnView.configureLayout(column.getVerticalContentAlignment(), minHeight: column.getMinHeight(), heightType: column.getHeight(), type: .column)
        
        if column.getVerticalContentAlignment() == .center, let topView = topSpacingView {
            let view = SpacingView()
            columnView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        }
        
        if let backgroundImage = column.getBackgroundImage(), let url = backgroundImage.getUrl() {
            columnView.setupBackgroundImageProperties(backgroundImage)
            rootView.registerImageHandlingView(columnView.backgroundImageView, for: url)
        }
        
        columnView.setupSelectAction(column.getSelectAction(), rootView: rootView)
        columnView.setupSelectActionAccessibility(on: columnView, for: column.getSelectAction())
     
        return columnView
    }
}
