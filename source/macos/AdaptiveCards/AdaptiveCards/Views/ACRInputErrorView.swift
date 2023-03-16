import AdaptiveCards_bridge
import AppKit

class ACRInputErrorView: NSView {
    let renderConfig: RenderConfig
    let hostConfig: ACSHostConfig
    let inputElement: ACSBaseInputElement
    let style: ACSContainerStyle
    struct Constants {
        static let padding: CGFloat = 4
    }
    
    // Label
    private (set) lazy var errorLabel: ACRInputLabelTextField = {
        let textLabel = ACRInputLabelTextField(inputElement: inputElement, renderConfig: renderConfig, hostConfig: hostConfig, style: style)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    // Image
    private (set) lazy var errorBadgeImage: NSImageView = {
        let warningResourceName = renderConfig.isDarkMode ? "warning-badge-filled-dark" : "warning-badge-filled-light"
        let warningBadgeImage = renderConfig.inputFieldConfig.errorBadgeImage ?? BundleUtils.getImage(warningResourceName, ofType: "png")
        let imageView = NSImageView()
        imageView.image = warningBadgeImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = NSColor.clear.cgColor
        return imageView
    }()
    
    init(inputElement: ACSBaseInputElement, renderConfig: RenderConfig, hostConfig: ACSHostConfig, style: ACSContainerStyle) {
        self.inputElement = inputElement
        self.renderConfig = renderConfig
        self.hostConfig = hostConfig
        self.style = style
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setAttributedString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.isHidden = true
        addSubview(errorBadgeImage)
        addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        errorBadgeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding).isActive = true
        errorBadgeImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        errorBadgeImage.setConstraintSize(from: renderConfig.inputFieldConfig.errorStateConfig.font)
        
        errorLabel.leadingAnchor.constraint(equalTo: errorBadgeImage.trailingAnchor, constant: Constants.padding).isActive = true
        errorLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setAttributedString() {
        let errorMessage = inputElement.getErrorMessage() ?? ""
        let errorStateConfig = renderConfig.inputFieldConfig.errorStateConfig
        let attributedErrorMessageString = NSMutableAttributedString(string: errorMessage)
        attributedErrorMessageString.addAttributes([.font: errorStateConfig.font, .foregroundColor: errorStateConfig.textColor], range: NSRange(location: 0, length: attributedErrorMessageString.length))
        errorLabel.attributedStringValue = attributedErrorMessageString
    }
}

extension NSImageView {
    func setConstraintSize(from font: NSFont) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        let pointHeight = font.pointSize + 2.0
        heightAnchor.constraint(equalToConstant: pointHeight).isActive = true
        widthAnchor.constraint(equalToConstant: ratio * pointHeight).isActive = true
    }
}
