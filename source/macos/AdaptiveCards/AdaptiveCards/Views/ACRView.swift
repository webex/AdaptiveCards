import AdaptiveCards_bridge
import AppKit

class ACRView: ACRColumnView {
    override init(style: ACSContainerStyle, hostConfig: ACSHostConfig) {
        super.init(style: style, hostConfig: hostConfig)
        setStyle(style, parentStyle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
