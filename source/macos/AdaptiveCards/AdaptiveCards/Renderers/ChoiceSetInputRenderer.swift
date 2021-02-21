import AdaptiveCards_bridge
import AppKit

class ChoiceSetInputRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ChoiceSetInputRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let choiceSetInput = element as? ACSChoiceSetInput else {
            return NSView()
        }
        if !choiceSetInput.getIsMultiSelect() {
            // style is compact or expanded
            if choiceSetInput.getChoiceSetStyle() == .compact {
                return  choiceSetCompactRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style)
            } else {
                // radio button renderer
                return choiceSetRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style)
            }
        }
        // display multi-select check-boxes
        return choiceSetRenderInternal(choiceSetInput: choiceSetInput, with: hostConfig, style: style)
    }
    
    func choiceSetRenderInternal(choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle) -> NSView {
        // Parse input default values for multi-select
        let defaultParsedValues = parseChoiceSetInputDefaultValues(value: choiceSetInput.getValue() ?? "")
        let isMultiSelect = choiceSetInput.getIsMultiSelect()
        let view = ACRChoiceSetFieldView()
        var buttons: [NSButton] = []
        for choice in choiceSetInput.getChoices() {
            let title = choice.getTitle() ?? ""
            let choiceButton: NSButton
            if isMultiSelect {
                // checkbox
                choiceButton = NSButton(checkboxWithTitle: title, target: self, action: Selector(("onclickButton")))
            } else {
                // radio box
                choiceButton = NSButton(radioButtonWithTitle: title, target: self, action: Selector(("onclickButton")))
            }
            choiceButton.attributedTitle = getAttributedString(title: title, with: hostConfig, style: style, wrap: choiceSetInput.getWrap())
            choiceButton.keyEquivalent = choice.getValue() ?? ""
            if defaultParsedValues.contains(choice.getValue() ?? "") {
                choiceButton.state = .on
            }
            buttons.append(choiceButton)
        }
        view.stackView = NSStackView(views: buttons)
        view.addSubview(view.stackView)
        view.setupConstraints()
        return view
    }
    func parseChoiceSetInputDefaultValues(value: String) -> [String] {
        let parsedValues = value.components(separatedBy: ",")
        return parsedValues
    }
}
// MARK: Extension
extension ChoiceSetInputRenderer {
    func choiceSetCompactRenderInternal (choiceSetInput: ACSChoiceSetInput, with hostConfig: ACSHostConfig, style: ACSContainerStyle) -> NSView {
        // compact button renderer
        let choiceSetFieldCompactView = ACRChoiceSetFieldCompactView()
        choiceSetFieldCompactView.autoenablesItems = false
        var index = 0
        if choiceSetInput.getPlaceholder() != "" {
            choiceSetFieldCompactView.addItem(withTitle: choiceSetInput.getPlaceholder() ?? "")
            if let menuItem = choiceSetFieldCompactView.item(at: 0) {
                menuItem.isEnabled = false
            }
            index += 1
        }
        for choice in choiceSetInput.getChoices() {
            let title = choice.getTitle() ?? ""
            choiceSetFieldCompactView.addItem(withTitle: "")
            let item = choiceSetFieldCompactView.item(at: index)
            item?.title = title
            item?.attributedTitle = getAttributedString(title: title, with: hostConfig, style: style, wrap: choiceSetInput.getWrap())
            if choiceSetInput.getValue() == choice.getValue() {
                choiceSetFieldCompactView.select(item)
            }
            index += 1
        }
        return choiceSetFieldCompactView
    }
    func getAttributedString(title: String, with hostConfig: ACSHostConfig, style: ACSContainerStyle, wrap: Bool) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString
        let resolvedTitle = wrap ? title + "\n" : title
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString = NSMutableAttributedString(string: resolvedTitle, attributes: [.paragraphStyle: paragraphStyle])
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString
    }
}
// MARK: ACRChoiceSetFieldView
class ACRChoiceSetFieldView: NSView {
    public var stackView = NSStackView()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupConstraints() {
        self.stackView.orientation = .vertical
        self.stackView.alignment = .leading
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    override var intrinsicContentSize: NSSize {
        return NSSize(width: super.intrinsicContentSize.width, height: self.stackView.fittingSize.height)
    }
}
// MARK: ACRChoiceSetFieldCompactView
class ACRChoiceSetFieldCompactView: NSPopUpButton {
    override func viewDidMoveToSuperview() {
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
