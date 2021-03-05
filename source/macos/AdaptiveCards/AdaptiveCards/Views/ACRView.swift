import AdaptiveCards_bridge
import AppKit

class ACRView: ACRColumnView {
    override init(style: ACSContainerStyle, hostConfig: ACSHostConfig) {
        super.init(style: style, hostConfig: hostConfig)
        if let paddingSpace = hostConfig.getSpacing()?.paddingSpacing, let padding = CGFloat(exactly: paddingSpace) {
            applyPadding(padding)
        }
    }
    
    override init(style: ACSContainerStyle, parentStyle: ACSContainerStyle, hostConfig: ACSHostConfig, superview: NSView) {
        super.init(style: style, parentStyle: parentStyle, hostConfig: hostConfig, superview: superview)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func addArrangedSubview(_ subview: NSView) {
        super.addArrangedSubview(subview)
        if subview is ACRContentStackView {
            subview.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
}
