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
        let rowStack = ACRFactSetStackView()
        let columnStack = ACRFactSetStackView()
        columnStack.orientation = .vertical
        
//        columnStack.distribution = .fill
        columnStack.alignment = .leading
        
//        columnStack.alignment = .bottom
        columnStack.translatesAutoresizingMaskIntoConstraints = false
//        columnStack.setContentHuggingPriority(.init(1000), for: .horizontal)
//        columnStack.alignment = .leading
        rowStack.orientation = NSUserInterfaceLayoutOrientation.horizontal
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        rowStack.alignment = .centerY
//        rowStack.alignment = .right
//        rowStack.translatesAutoresizingMaskIntoConstraints = false
        var titleExists = false
        for fact in factArray {
            if fact.getTitle() != "" {
                titleExists = true
            }
        }
//        print(titleEmpty)
        
//        for fact in factArray {
//            let view = ACRFactSetElement()
//            if titleExists { view.setTitleWidth(width: factsetConfig?.title.maxWidth) }
//            view.setLabel(string: fact.getTitle())
//            view.setValue(string: fact.getValue())
//            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
//                view.labelText.textColor = textColor
//                view.valueText.textColor = textColor
//            }
//            if !titleExists {
//                view.titleIsEmpty()
//            }
            
//            view.labelText.preferredMaxLayoutWidth = columnStack.frame.width / 2
//            view.valueText.preferredMaxLayoutWidth = columnStack.frame.width / 2
//            view.valueText.widthAnchor.constraint(equalTo: columnStack.widthAnchor, multiplier: 0.7).isActive = true
//        view.leadingAnchor.constraint(equalTo: columnStack.leadingAnchor).isActive = true
//            view.contentView.leadingAnchor.constraint(equalTo: columnStack.leadingAnchor).isActive = true
//            view.contentView.trailingAnchor.constraint(equalTo: columnStack.trailingAnchor).isActive = true
//            view.contentView.topAnchor.constraint(equalTo: columnStack.topAnchor).isActive = true
//            view.contentView.bottomAnchor.constraint(equalTo: columnStack.bottomAnchor).isActive = true
//            view.labelText.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            view.setContentHuggingPriority(.init(1), for: .horizontal)
//            columnStack.addConstraint(view.widthAnchor.constraint(equalTo: columnStack.widthAnchor, multiplier: 0.5))
//            view.contentView.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
//            let horView = NSStackView()
//            horView.orientation = .horizontal
//
//            horView.addArrangedSubview(view)
            
//            columnStack.addArrangedSubview(view)
            
//            columnStack.addArrangedSubview(rowStack)
//            columnStack.addView(view, in: .bottom)
            
//        }
        let titleStack = ACRFactSetStackView()
        let valueStack = ACRFactSetStackView()
        titleStack.orientation = .vertical
        valueStack.orientation = .vertical
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        valueStack.translatesAutoresizingMaskIntoConstraints = false
        
        for fact in factArray {
            let titleView = TitleFact()
            let valueView = ACRFactTextField()
            if titleExists { titleView.setupMaxWidth(width: factsetConfig?.title.maxWidth) }
            titleView.titleText.setLabel(string: fact.getTitle())
            valueView.setLabel(string: fact.getValue())
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
                titleView.titleText.labelText.textColor = textColor
                valueView.labelText.textColor = textColor
            }
            if !(titleView.titleText.labelText.stringValue.isEmpty) || !(valueView.labelText.stringValue.isEmpty) {
                titleStack.addArrangedSubview(titleView.titleText)
                valueStack.addArrangedSubview(valueView)
//                titleView.titleText.heightAnchor.constraint(equalTo: valueView.heightAnchor).isActive = true
                
            }
        }
//        rowStack.insertView(titleStack, at: 0, in: .leading)
//        rowStack.insertView(valueStack, at: 0, in: .trailing)
        rowStack.addArrangedSubview(titleStack)
        titleStack.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 0.5).isActive = true
        rowStack.addArrangedSubview(valueStack)
        valueStack.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 0.5).isActive = true
        
        let temp = rowStack.arrangedSubviews
        guard let titleStackagain = temp[0] as? ACRFactSetStackView else { return NSView() }
        guard let valueStackagain = temp[1] as? ACRFactSetStackView else { return NSView() }
        for (index, elem) in titleStackagain.arrangedSubviews.enumerated() {
            guard let titleView = elem as? ACRFactTextField else { return ACRFactTextField() }
            let valueArray = valueStackagain.arrangedSubviews
            guard let valueView = valueArray[index] as? ACRFactTextField else { return ACRFactTextField() }
            titleView.heightAnchor.constraint(equalTo: valueView.heightAnchor).isActive = true
        }
        return rowStack
//        return columnStack
    }
}
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
        titleText.labelText.font = NSFont.boldSystemFont(ofSize: 12)
    }
    
    func setupMaxWidth(width: NSNumber?) {
        titleText.labelText.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(truncating: width ?? 150)).isActive = true
    }
}
// class ValueFact: ACRFactTextField {
//    var valueText = ACRFactTextField()
//
//    override init() {
//        super.init()
//        setupValue()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupTitle() {
//        titleText.labelText.font = NSFont.boldSystemFont(ofSize: 12)
//
//    }
//
//    func setupMaxWidth(width: NSNumber?) {
//        titleText.labelText.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(truncating: width ?? 150)).isActive = true
//    }
// }
