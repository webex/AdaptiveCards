import AdaptiveCards_bridge
import AppKit

class ACRInputErrorTextField: ACRInputLabelTextField {
    override init(inputElement: ACSBaseInputElement, renderConfig: RenderConfig, hostConfig: ACSHostConfig, style: ACSContainerStyle) {
        super.init(inputElement: inputElement, renderConfig: renderConfig, hostConfig: hostConfig, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupProperties() {
        super.setupProperties()
        self.isHidden = true
    }
    
    override func setAttributedString() {
        guard let errorMessage = inputElement.getErrorMessage(), !errorMessage.isEmpty else { return }
        let attributedErrorMessageString = NSMutableAttributedString(string: errorMessage)
        let errorStateConfig = renderConfig.inputFieldConfig.errorStateConfig
        attributedErrorMessageString.addAttributes([.font: errorStateConfig.font, .foregroundColor: errorStateConfig.textColor], range: NSRange(location: 0, length: attributedErrorMessageString.length))
        self.attributedStringValue = attributedErrorMessageString
    }
}
