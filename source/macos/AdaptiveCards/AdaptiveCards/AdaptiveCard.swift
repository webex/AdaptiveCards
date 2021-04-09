import AdaptiveCards_bridge
import AppKit

public protocol AdaptiveCardActionDelegate: AnyObject {
    func adaptiveCard(_ adaptiveCard: NSView, didSelectOpenURL urlString: String, actionView: NSView)
    func adaptiveCard(_ adaptiveCard: NSView, didSubmitUserResponses dict: [String: Any], actionView: NSView)
}

public protocol AdaptiveCardResourceResolver: AnyObject {
    func adaptiveCard(_ adaptiveCard: ImageResourceHandlerView, dimensionsForImageWith url: String) -> NSSize?
    func adaptiveCard(_ adaptiveCard: ImageResourceHandlerView, requestImageFor url: String)
}

enum HostConfigParseError: Error {
    case resultIsNil, configIsNil
}

open class AdaptiveCard {
    public static func from(jsonString: String) -> ACSParseResult {
        return BridgeConverter.parseAdaptiveCard(fromJSON: jsonString)
    }
    
    public static func parseHostConfig(from jsonString: String) -> Result<ACSHostConfig, Error> {
        guard let result = BridgeConverter.parseHostConfig(fromJSON: jsonString) else {
            return .failure(HostConfigParseError.resultIsNil)
        }
        guard result.isValid, let hostConfig = result.config else {
            return .failure(result.error ?? HostConfigParseError.configIsNil)
        }
        return .success(hostConfig)
    }
    
    public static func render(card: ACSAdaptiveCard, with hostConfig: ACSHostConfig, width: CGFloat, actionDelegate: AdaptiveCardActionDelegate?, resourceResolver: AdaptiveCardResourceResolver?, config: RenderConfig = .default) -> NSView {
        AdaptiveCardRenderer.shared.actionDelegate = actionDelegate
        AdaptiveCardRenderer.shared.resolverDelegate = resourceResolver
        return AdaptiveCardRenderer.shared.renderAdaptiveCard(card, with: hostConfig, width: width, config: config)
    }
}

public struct RenderConfig {
    public static let `default` = RenderConfig(isDarkMode: false, buttonConfig: .default)
    let isDarkMode: Bool
    let buttonConfig: ButtonConfig
    
    public init(isDarkMode: Bool, buttonConfig: ButtonConfig) {
        self.isDarkMode = isDarkMode
        self.buttonConfig = buttonConfig
    }
}

public struct ButtonColorConfig {
    public static let `default` = ButtonColorConfig()
    
    // buttonColor
    let buttonColor: NSColor
    let activeButtonColor: NSColor
    let hoverButtonColor: NSColor
    
    // textColor
    let textColor: NSColor
    let activeTextColor: NSColor
    
    // borderColor
    let borderColor: NSColor
    let activeBorderColor: NSColor
        
    public init(buttonColor: NSColor = .blue, activeButtonColor: NSColor = .systemBlue, hoverButtonColor: NSColor = .systemBlue, textColor: NSColor = .black, activeTextColor: NSColor = .black, borderColor: NSColor = .blue, activeBorderColor: NSColor = .systemBlue) {
        self.buttonColor = buttonColor
        self.activeButtonColor = activeButtonColor
        self.hoverButtonColor = hoverButtonColor
        self.textColor = textColor
        self.activeTextColor = activeTextColor
        self.borderColor = borderColor
        self.activeBorderColor = activeBorderColor
    }
}

public struct ButtonConfig {
    public static let `default` = ButtonConfig()
    
    let positive: ButtonColorConfig
    let destructive: ButtonColorConfig
    let `default`: ButtonColorConfig
    let inline: ButtonColorConfig
    
    public init(positive: ButtonColorConfig = .default, destructive: ButtonColorConfig = .default, default: ButtonColorConfig = .default, inline: ButtonColorConfig = .default) {
        self.positive = positive
        self.destructive = destructive
        self.default = `default`
        self.inline = inline
    }
}
