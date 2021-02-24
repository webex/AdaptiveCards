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
        let columnStack = ACRFactSetStackView()
        let rowStack = NSStackView()
        columnStack.orientation = .vertical
//        columnStack.distribution = .fill
        columnStack.alignment = .leading
//        columnStack.alignment = .bottom
        columnStack.translatesAutoresizingMaskIntoConstraints = false
//        columnStack.setContentHuggingPriority(.init(1000), for: .horizontal)
//        columnStack.alignment = .leading
        rowStack.orientation = NSUserInterfaceLayoutOrientation.horizontal
//        rowStack.alignment = .right
//        rowStack.translatesAutoresizingMaskIntoConstraints = false
        var titleExists = false
        for fact in factArray {
            if fact.getTitle() != "" {
                titleExists = true
            }
        }
//        print(titleEmpty)
        for fact in factArray {
            let view = ACRFactSetElement()
//            if titleExists { view.setLabel(string: fact.getTitle()) }
            view.setLabel(string: fact.getTitle())
            view.setValue(string: fact.getValue())
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
                view.labelText.textColor = textColor
                view.valueText.textColor = textColor
            }
            if !titleExists {
                view.titleIsEmpty()
            }
            
            let titleLabel: NSTextField = .init(string: fact.getTitle() ?? "")
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.isEditable = false
//            titleLabel.preferredMaxLayoutWidth = rowStack.frame.width / 2
            titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            titleLabel.usesSingleLineMode = false
            titleLabel.layout()
            
            let valueLabel: NSTextField = .init(string: fact.getValue() ?? "")
            valueLabel.lineBreakMode = .byWordWrapping
            valueLabel.isEditable = false
//            valueLabel.preferredMaxLayoutWidth = rowStack.frame.width / 2
            valueLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            valueLabel.usesSingleLineMode = false
            valueLabel.layout()
            rowStack.addArrangedSubview(titleLabel)
            rowStack.addArrangedSubview(valueLabel)
            
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
            columnStack.addArrangedSubview(view)
//            columnStack.addArrangedSubview(rowStack)
//            columnStack.addView(view, in: .bottom)
        }
        return columnStack
    }
}
