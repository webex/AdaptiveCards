import AdaptiveCards_bridge
import AppKit

class ACRInputLabelTextField: NSTextField {
    let renderConfig: RenderConfig
    let hostConfig: ACSHostConfig
    let inputElement: ACSBaseInputElement
    let style: ACSContainerStyle
    
    init(inputElement: ACSBaseInputElement, renderConfig: RenderConfig, hostConfig: ACSHostConfig, style: ACSContainerStyle) {
        self.inputElement = inputElement
        self.renderConfig = renderConfig
        self.hostConfig = hostConfig
        self.style = style
        super.init(frame: .zero)
        setupProperties()
        setAttributedString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProperties() {
        allowsEditingTextAttributes = true
        isEditable = false
        isBordered = false
        isSelectable = true
        setAccessibilityRole(.none)
        backgroundColor = .clear
    }
    
    func setAttributedString() {
        guard let label = inputElement.getLabel(), !label.isEmpty else { return }
        let attributedString = NSMutableAttributedString(string: label)
        let errorStateConfig = renderConfig.inputFieldConfig.errorStateConfig
        let isRequiredSuffix = (hostConfig.getInputs()?.label.requiredInputs.suffix ?? "").isEmpty ? "*" : hostConfig.getInputs()?.label.requiredInputs.suffix ?? "*"
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor, .font: NSFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: attributedString.length))
        }
        if inputElement.getIsRequired() {
            attributedString.append(NSAttributedString(string: " " + isRequiredSuffix, attributes: [.foregroundColor: errorStateConfig.textColor, .font: NSFont.systemFont(ofSize: 16)]))
        }
        self.attributedStringValue = attributedString
    }
}
