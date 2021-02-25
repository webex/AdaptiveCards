import AdaptiveCards_bridge
import AppKit

class FactSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = FactSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let factSet = element as? ACSFactSet else {
            logError("Element is not of type ACSFactSet")
            return NSView()
        }
        let factArray = factSet.getFacts()
        let factsetConfig = hostConfig.getFactSet()
        
        // Create horizontal Stack to add both views
        let horizontalStack = ACRFactSetStackView()
        horizontalStack.orientation = NSUserInterfaceLayoutOrientation.horizontal
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Create stacks to hold title and value of FactSet
        let titleStack = NSStackView()
        let valueStack = NSStackView()
        titleStack.orientation = .vertical
        valueStack.orientation = .vertical
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        valueStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Main loop to iterate over Array of facts
        for fact in factArray {
            let titleView = TitleFact()
            let valueView = ACRFactTextField()
            titleView.titleText.setLabel(string: fact.getTitle())
            valueView.setLabel(string: fact.getValue())
            
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
                titleView.titleText.labelText.textColor = textColor
                valueView.labelText.textColor = textColor
            }
            
            if !(titleView.titleText.labelText.stringValue.isEmpty) || !(valueView.labelText.stringValue.isEmpty) {
                titleStack.addArrangedSubview(titleView.titleText)
                valueStack.addArrangedSubview(valueView)
            }
        }
        
        // Add both elements into the Horizontal Stack
        horizontalStack.addArrangedSubview(titleStack)
        horizontalStack.addArrangedSubview(valueStack)
        
        // Add constraints once all the views are in the same view heirarchy
        let horizontalStackViews = horizontalStack.arrangedSubviews
        guard let titleStackagain = horizontalStackViews[0] as? NSStackView else { return NSView() }
        guard let valueStackagain = horizontalStackViews[1] as? NSStackView else { return NSView() }
        
        titleStackagain.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor).isActive = true
        titleStackagain.topAnchor.constraint(equalTo: horizontalStack.topAnchor).isActive = true
        titleStackagain.bottomAnchor.constraint(equalTo: horizontalStack.bottomAnchor).isActive = true
        // Spacing between title and value in the horizontal Stack
        titleStackagain.trailingAnchor.constraint(equalTo: valueStackagain.leadingAnchor, constant: -10).isActive = true
        // Getting Max width from Host config if it exists
        titleStackagain.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(truncating: factsetConfig?.title.maxWidth ?? 150)).isActive = true

        valueStackagain.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor).isActive = true
        valueStackagain.topAnchor.constraint(equalTo: horizontalStack.topAnchor).isActive = true
        valueStackagain.bottomAnchor.constraint(equalTo: horizontalStack.bottomAnchor).isActive = true

        // Make the height of each title and value equal
        for (index, elem) in titleStackagain.arrangedSubviews.enumerated() {
            guard let titleView = elem as? ACRFactTextField else { return ACRFactTextField() }
            let valueArray = valueStackagain.arrangedSubviews
            guard let valueView = valueArray[index] as? ACRFactTextField else { return ACRFactTextField() }
            titleView.heightAnchor.constraint(equalTo: valueView.heightAnchor).isActive = true
        }
        
        return horizontalStack
    }
}

// MARK: Extend ACRFactTextField to Make title bold
class TitleFact: ACRFactTextField {
    var titleText = ACRFactTextField()
    
    override init() {
        super.init()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle() {
        // TODO: Make it get all properties from host config
        titleText.labelText.font = NSFont.boldSystemFont(ofSize: 12)
    }
}
