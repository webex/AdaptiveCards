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
        let errorMessage = inputElement.getErrorMessage() ?? ""
        let errorStateConfig = renderConfig.inputFieldConfig.errorStateConfig
        let warningResourceName = renderConfig.isDarkMode ? "warning-badge-filled-dark" : "warning-badge-filled-light"
        let warningBadgeImage = renderConfig.inputFieldConfig.warningBadgeImage ?? BundleUtils.getImage(warningResourceName, ofType: "png")
        
        let attachment = NSTextAttachment()
        attachment.image = warningBadgeImage
        attachment.setImageBounds(from: errorStateConfig.font)
        let attributedErrorMessageString = NSMutableAttributedString(attachment: attachment)
        attributedErrorMessageString.append(NSAttributedString(string: errorMessage.isEmpty ? "" : " \(errorMessage)"))
        
        attributedErrorMessageString.addAttributes([.font: errorStateConfig.font, .foregroundColor: errorStateConfig.textColor], range: NSRange(location: 0, length: attributedErrorMessageString.length))
        self.attributedStringValue = attributedErrorMessageString
    }
}
