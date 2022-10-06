import AdaptiveCards_bridge
import AppKit

class ColumnSetRenderer: BaseCardElementRendererProtocol {
    static let shared = ColumnSetRenderer()
    
    struct Constants {
        static let kFillColumnViewVerticalLayoutConstraintPriority = NSLayoutConstraint.Priority.defaultLow - 1
        static let maxCardWidth: Float = 350.0
    }
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let columnSet = element as? ACSColumnSet else {
            logError("Element is not of type ACSColumnSet")
            return NSView()
        }
        let columnSetView = ACRColumnSetView(style: columnSet.getStyle(), parentStyle: style, hostConfig: hostConfig, renderConfig: config, superview: parentView, needsPadding: columnSet.getPadding())
        columnSetView.translatesAutoresizingMaskIntoConstraints = false
        columnSetView.orientation = .horizontal
        var numberOfAutoItems = 0
        var numberOfStretchItems = 0
        var numberOfWeightedItems = 0
        let totalColumns = columnSet.getColumns().count
        var totalPaddingSpace = Float.zero
        var columnViews: [NSView] = []
        
        for (index, column) in columnSet.getColumns().enumerated() {
            let isfirstElement = index == 0
            let width = ColumnWidth(columnWidth: column.getWidth(), pixelWidth: column.getPixelWidth())
            if width.isWeighted { numberOfWeightedItems += 1 }
            if width == .stretch { numberOfStretchItems += 1 }
            if width == .auto { numberOfAutoItems += 1 }
            let requestedSpacing = column.getSpacing()
            totalPaddingSpace += HostConfigUtils.getSpacing(requestedSpacing, with: hostConfig).floatValue
            let columnView = ColumnRenderer.shared.render(element: column, with: hostConfig, style: columnSet.getStyle(), rootView: rootView, parentView: columnSetView, inputs: [], config: config)
            columnViews.append(columnView)
            updateColumnSetSeparatorAndAlignment(columnView: columnView, column: column, columnSetView: columnSetView, rootView: rootView, columnSet: columnSet, isfirstElement: isfirstElement, hostConfig: hostConfig)
            BaseCardElementRenderer.shared.configBleed(collectionView: columnView, parentView: columnSetView, with: hostConfig, element: column, parentElement: columnSet)
        }
        
        // Add SelectAction
        columnSetView.setupSelectAction(columnSet.getSelectAction(), rootView: rootView)
        columnSetView.setupSelectActionAccessibility(on: columnSetView, for: columnSet.getSelectAction())
        
        if numberOfStretchItems == totalColumns && !columnViews.isEmpty {
            let firstColumn = columnViews[0]
            for index in (1..<columnViews.count) {
                columnViews[index].widthAnchor.constraint(equalTo: firstColumn.widthAnchor).isActive = true
            }
            columnSetView.distribution = .fill
        } else if numberOfAutoItems == totalColumns {
            let width = (Constants.maxCardWidth - totalPaddingSpace) / Float(columnViews.count)
            for index in (0 ..< columnViews.count) {
                let widthAnchor = columnViews[index].widthAnchor.constraint(equalToConstant: CGFloat(width))
                widthAnchor.priority = .defaultHigh
                widthAnchor.isActive = true
            }
            columnSetView.distribution = .gravityAreas
        } else if numberOfStretchItems == 0 && numberOfWeightedItems == 0 {
            columnSetView.distribution = .gravityAreas
        } else {
            guard columnViews.count == totalColumns else {
                logError("ArrangedSubViews count mismatch")
                return columnSetView
            }
            columnSetView.distribution = .fill
            
            var weightedColumnViews: [NSView] = []
            var weightedValues: [CGFloat] = []
            var firstWeightedValue: CGFloat?
            
            for (index, column) in columnSet.getColumns().enumerated() {
                guard let width = column.getWidth(), let weighted = Int(width) else { continue }
                weightedColumnViews.append(columnViews[index])
                guard let baseWeight = firstWeightedValue else {
                    firstWeightedValue = CGFloat(weighted)
                    weightedValues.append(1)
                    continue
                }
                weightedValues.append(CGFloat(weighted) / baseWeight)
            }
            if weightedColumnViews.count > 1 {
                for index in (1 ..< weightedColumnViews.count) {
                    weightedColumnViews[index].widthAnchor.constraint(equalTo: weightedColumnViews[0].widthAnchor, multiplier: weightedValues[index]).isActive = true
                }
            }
            if numberOfStretchItems > 1 {
                let stretchColumnIndices = getIndicesOfStretchedColumns(of: columnSet)
                guard numberOfStretchItems == stretchColumnIndices.count else {
                    logError("indices count must be equal to numberOfStretchItems here")
                    return columnSetView
                }
                
                for index in (1 ..< stretchColumnIndices.count) {
                    columnViews[stretchColumnIndices[index]].widthAnchor.constraint(equalTo: columnViews[stretchColumnIndices[0]].widthAnchor).isActive = true
                }
            }
        }
        columnSetView.configureLayoutAndVisibility(columnSet.getVerticalContentAlignment(), minHeight: columnSet.getMinHeight(), heightType: columnSet.getHeight(), type: .columnSet)
        return columnSetView
    }
    
    private func getIndicesOfStretchedColumns(of columnSet: ACSColumnSet) -> [Int] {
        return columnSet.getColumns().enumerated().compactMap { index, column in
            let width = ColumnWidth(columnWidth: column.getWidth(), pixelWidth: column.getPixelWidth())
            return width == .stretch ? index : nil
        }
    }
    
    private func updateColumnSetSeparatorAndAlignment(columnView: NSView, column: ACSColumn, columnSetView: ACRContentStackView, rootView: ACRView, columnSet: ACSColumnSet, isfirstElement: Bool, hostConfig: ACSHostConfig) {
        guard let columnView = columnView as? ACRColumnView else { return }
        let gravityArea: NSStackView.Gravity = columnSet.getHorizontalAlignment() == .center ? .center: (columnSet.getHorizontalAlignment() == .right ? .trailing: .leading)
        var separator: SpacingView?
        if !isfirstElement {
            // For seperator and spacing
            separator = SpacingView.renderSpacer(elem: column, forSuperView: columnSetView, withHostConfig: hostConfig)
        }
        columnView.identifier = NSUserInterfaceItemIdentifier(column.getId() ?? "")
        columnSetView.addView(columnView, in: gravityArea)
        columnSetView.updateLayoutAndVisibilityOfRenderedView(columnView, acoElement: column, separator: separator, rootView: rootView)
        
        // Keep Column view horizontal and vertical stretch inside the ColumnSet
        /*
         B = ColumnSet StackView
         A = Column view
         B+---------------------------+
          | A+---------+ +---------+  |
          |  | H:249   | |  H:249  |  |
          |  | V:250   | |  V:250  |  |
          |  +---------+ +---------+  |
          |                           |
          +---------------------------+
         
         B+---------------------------+
          | A+---------+ +---------+  |
          |  | H:249   | |  H:249  |  |
          |  | V:249   | |  V:249  |  |
          |  |         | |         |  |
          |  +---------+ +---------+  |
          +---------------------------+
         */
        columnView.setContentHuggingPriority(Constants.kFillColumnViewVerticalLayoutConstraintPriority, for: .vertical)
    }
}
