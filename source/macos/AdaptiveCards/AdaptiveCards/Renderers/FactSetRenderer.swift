import AdaptiveCards_bridge
import AppKit

class FactSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = FactSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let factSet = element as? ACSFactSet else {
            logError("Element is not of type ACSFactSet")
            return NSView()
        }
//        let factSetView = ACRFactSetView()
        let factArray = factSet.getFacts()
//        let view1 = [ACRFactSetElement()]
        let columnStack = CustomStackView()
//        columnStack.orientation = .vertical
//        columnStack.translatesAutoresizingMaskIntoConstraints = false
//        columnStack.alignment = .centerX
//        columnStack.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
//        columnStack.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        for fact in factArray {
//            print(fact.getTitle(), fact.getValue())
            let view = ACRFactSetElement()
            view.setLabel(string: fact.getTitle())
            view.setValue(string: fact.getValue())
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
                view.labelText.textColor = textColor
                view.valueText.textColor = textColor
            }
            view.labelText.preferredMaxLayoutWidth = columnStack.stackView.frame.width / 2
            view.valueText.preferredMaxLayoutWidth = columnStack.stackView.frame.width / 2
//            return view
            columnStack.stackView.addView(view, in: .bottom)
        }
//        columnStack.layout()
        columnStack.setupConstraints()
//        columnStack.stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return columnStack.stackView
    }
}

class CustomStackView: NSView {
    public var stackView = NSStackView()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
//        setupConstraints()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupConstraints() {
        self.stackView.orientation = .vertical
        self.stackView.alignment = .centerX
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
//        print(self.stackView.intrinsicContentSize)
//        self.stackView.setClippingResistancePriority(.fittingSizeCompression, for: .vertical)
//        self.stackView.set
    }
    override var intrinsicContentSize: NSSize {
        print(self.stackView.fittingSize.height)
        return NSSize(width: super.intrinsicContentSize.width, height: self.stackView.fittingSize.height)
    }
}
