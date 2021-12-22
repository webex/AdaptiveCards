import AdaptiveCards_bridge
import AppKit

public protocol AdaptiveCardActionDelegate: AnyObject {
    func adaptiveCard(_ adaptiveCard: NSView, didSelectOpenURL urlString: String, actionView: NSView)
    func adaptiveCard(_ adaptiveCard: NSView, didSubmitUserResponses dict: [String: Any], actionView: NSView)
    func adaptiveCard(_ adaptiveCard: NSView, didShowCardWith actionView: NSView, previousHeight: CGFloat, newHeight: CGFloat)
    func adaptiveCard(_ adaptiveCard: NSView, didUpdateBoundsFrom oldValue: NSRect, to newValue: NSRect)
}

public protocol AdaptiveCardResourceResolver: AnyObject {
    func adaptiveCard(_ adaptiveCard: ImageResourceHandlerView, dimensionsForImageWith url: String) -> NSSize?
    func adaptiveCard(_ adaptiveCard: ImageResourceHandlerView, requestImageFor url: String)
    func adaptiveCard(_ adaptiveCard: NSView, attributedStringFor htmlString: String) -> NSAttributedString?
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
        return AdaptiveCardRenderer.shared.renderAdaptiveCard(card, with: hostConfig, width: width, config: config, actionDelegate: actionDelegate, resourceResolver: resourceResolver)
    }
}

public struct RenderConfig {
    public static let `default` = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: false, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
    let isDarkMode: Bool
    let buttonConfig: ButtonConfig
    // swiftlint:disable identifier_name
    let supportsSchemeV1_3: Bool
    let hyperlinkColorConfig: HyperlinkColorConfig
    let checkBoxButtonConfig: ChoiceSetButtonConfig?
    let radioButtonConfig: ChoiceSetButtonConfig?
    let inputFieldConfig: InputFieldConfig
    public let localisedStringConfig: LocalisedStringConfig
    
    public init(isDarkMode: Bool, buttonConfig: ButtonConfig, supportsSchemeV1_3: Bool, hyperlinkColorConfig: HyperlinkColorConfig, inputFieldConfig: InputFieldConfig, checkBoxButtonConfig: ChoiceSetButtonConfig?, radioButtonConfig: ChoiceSetButtonConfig?, localisedStringConfig: LocalisedStringConfig?) {
        self.isDarkMode = isDarkMode
        self.buttonConfig = buttonConfig
		self.supportsSchemeV1_3 = supportsSchemeV1_3
        self.hyperlinkColorConfig = hyperlinkColorConfig
        self.checkBoxButtonConfig = checkBoxButtonConfig
        self.radioButtonConfig = radioButtonConfig
        self.inputFieldConfig = inputFieldConfig
        self.localisedStringConfig = localisedStringConfig ?? .default
    }
}

public struct ButtonColorConfig {
    // buttonColor
    let buttonColor: NSColor
    let selectedButtonColor: NSColor
    let hoverButtonColor: NSColor
    
    // textColor
    let textColor: NSColor
    let selectedTextColor: NSColor
    
    // borderColor
    let borderColor: NSColor
    let selectedBorderColor: NSColor
    
    // borderRequired:
    let wantsBorder: Bool
        
    public init(buttonColor: NSColor, selectedButtonColor: NSColor, hoverButtonColor: NSColor, textColor: NSColor, selectedTextColor: NSColor, borderColor: NSColor, selectedBorderColor: NSColor, wantsBorder: Bool) {
        self.buttonColor = buttonColor
        self.selectedButtonColor = selectedButtonColor
        self.hoverButtonColor = hoverButtonColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.borderColor = borderColor
        self.selectedBorderColor = selectedBorderColor
        self.wantsBorder = wantsBorder
    }
}

public struct ButtonConfig {
    public static let `default` = ButtonConfig(positive: .init(buttonColor: .green, selectedButtonColor: .systemGreen, hoverButtonColor: .systemGreen, textColor: .white, selectedTextColor: .white, borderColor: .green, selectedBorderColor: .systemGreen, wantsBorder: true), destructive: .init(buttonColor: .systemRed, selectedButtonColor: .red, hoverButtonColor: .red, textColor: .white, selectedTextColor: .white, borderColor: .systemRed, selectedBorderColor: .red, wantsBorder: true), default: .init(buttonColor: .systemBlue, selectedButtonColor: .blue, hoverButtonColor: .blue, textColor: .white, selectedTextColor: .white, borderColor: .systemBlue, selectedBorderColor: .blue, wantsBorder: true), inline: .init(buttonColor: .systemBlue, selectedButtonColor: .blue, hoverButtonColor: .blue, textColor: .white, selectedTextColor: .white, borderColor: .systemBlue, selectedBorderColor: .blue, wantsBorder: true), font: .systemFont(ofSize: 12), buttonContentInsets: NSEdgeInsets(top: 5, left: 16, bottom: 5, right: 16), chevronUpImage: nil, chevronDownImage: nil)
    
    let positive: ButtonColorConfig
    let destructive: ButtonColorConfig
    let `default`: ButtonColorConfig
    let inline: ButtonColorConfig
    public let font: NSFont
    public let buttonContentInsets: NSEdgeInsets
    public let chevronUpImage: NSImage?
    public let chevronDownImage: NSImage?
        
    public init(positive: ButtonColorConfig, destructive: ButtonColorConfig, default: ButtonColorConfig, inline: ButtonColorConfig, font: NSFont, buttonContentInsets: NSEdgeInsets, chevronUpImage: NSImage?, chevronDownImage: NSImage?) {
        self.positive = positive
        self.destructive = destructive
        self.default = `default`
        self.inline = inline
        self.font = font
        self.buttonContentInsets = buttonContentInsets
        self.chevronUpImage = chevronUpImage
        self.chevronDownImage = chevronDownImage
    }
}

public struct HyperlinkColorConfig {
    public static let `default` = HyperlinkColorConfig(foregroundColor: .systemBlue, isUnderlined: false, underlineColor: .blue, underlineStyle: .single)
    
    let foregroundColor: NSColor
    let isUnderlined: Bool
    let underlineColor: NSColor
    let underlineStyle: NSUnderlineStyle
    
    public init(foregroundColor: NSColor, isUnderlined: Bool, underlineColor: NSColor, underlineStyle: NSUnderlineStyle) {
        self.foregroundColor = foregroundColor
        self.isUnderlined = isUnderlined
        self.underlineColor = isUnderlined ? underlineColor : .clear
        self.underlineStyle = underlineStyle
    }
}

public struct ChoiceSetButtonConfig {
    let selectedIcon: NSImage
    let normalIcon: NSImage
    let selectedHighlightedIcon: NSImage
    let highlightedIcon: NSImage
    let elementSpacing: CGFloat
    
    public init(selectedIcon: NSImage, normalIcon: NSImage, selectedHighlightedIcon: NSImage, highlightedIcon: NSImage, elementSpacing: CGFloat) {
        self.selectedIcon = selectedIcon
        self.normalIcon = normalIcon
        self.selectedHighlightedIcon = selectedHighlightedIcon
        self.highlightedIcon = highlightedIcon
        self.elementSpacing = elementSpacing
    }
}
public struct InputFieldConfig {
    public static let `default` = InputFieldConfig(height: 20, leftPadding: 0, rightPadding: 0, yPadding: 0, focusRingCornerRadius: 0, borderWidth: 0.3, wantsClearButton: false, clearButtonImage: nil, calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 12), highlightedColor: .lightGray, backgroundColor: .white, borderColor: .darkGray, activeBorderColor: .darkGray, placeholderTextColor: .placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 0, left: 2, bottom: 0, right: 0), errorStateConfig: .default)
    public static let darkDefault = InputFieldConfig(height: 20, leftPadding: 0, rightPadding: 0, yPadding: 0, focusRingCornerRadius: 0, borderWidth: 0.3, wantsClearButton: false, clearButtonImage: nil, calendarImage: nil, clockImage: nil, font: .systemFont(ofSize: 12), highlightedColor: .darkGray, backgroundColor: NSColor(white: 0.11, alpha: 1), borderColor: .lightGray, activeBorderColor: .lightGray, placeholderTextColor: .placeholderTextColor, multilineFieldInsets: NSEdgeInsets(top: 0, left: 2, bottom: 0, right: 0), errorStateConfig: .default)
    
    public let height: CGFloat
    public let leftPadding: CGFloat
    public let rightPadding: CGFloat
    public let yPadding: CGFloat
    public let focusRingCornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let wantsClearButton: Bool
    public let clearButtonImage: NSImage?
    public let calendarImage: NSImage?
    public let clockImage: NSImage?
    public let font: NSFont
    public let highlightedColor: NSColor
    public let backgroundColor: NSColor
    public let borderColor: NSColor
    public let activeBorderColor: NSColor
    public let placeholderTextColor: NSColor
    public let multilineFieldInsets: NSEdgeInsets
    public let errorStateConfig: ErrorStateConfig
    
    public init(height: CGFloat, leftPadding: CGFloat, rightPadding: CGFloat, yPadding: CGFloat, focusRingCornerRadius: CGFloat, borderWidth: CGFloat, wantsClearButton: Bool, clearButtonImage: NSImage?, calendarImage: NSImage?, clockImage: NSImage?, font: NSFont, highlightedColor: NSColor, backgroundColor: NSColor, borderColor: NSColor, activeBorderColor: NSColor, placeholderTextColor: NSColor, multilineFieldInsets: NSEdgeInsets, errorStateConfig: ErrorStateConfig) {
        self.height = height
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.yPadding = yPadding
        self.focusRingCornerRadius = focusRingCornerRadius
        self.borderWidth = borderWidth
        self.wantsClearButton = wantsClearButton
        self.clearButtonImage = clearButtonImage
        self.calendarImage = calendarImage
        self.clockImage = clockImage
        self.font = font
        self.highlightedColor = highlightedColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.activeBorderColor = activeBorderColor
        self.placeholderTextColor = placeholderTextColor
        self.multilineFieldInsets = multilineFieldInsets
        self.errorStateConfig = errorStateConfig
    }
    
    public struct ErrorStateConfig {
        public static let `default` = ErrorStateConfig(font: .systemFont(ofSize: 10), textColor: .systemRed, borderColor: .systemRed, backgroundColor: NSColor.systemRed.withAlphaComponent(0.1))

        public let font: NSFont
        public let textColor: NSColor
        public let borderColor: NSColor
        public let backgroundColor: NSColor
        
        public init(font: NSFont, textColor: NSColor, borderColor: NSColor, backgroundColor: NSColor) {
            self.font = font
            self.textColor = textColor
            self.borderColor = borderColor
            self.backgroundColor = backgroundColor
        }
    }
}

public struct LocalisedStringConfig {
    public static let `default` = LocalisedStringConfig(choiceSetCompactAccessibilityRoleDescriptor: "Drop Down", inputNumberAccessibilityTitle: "Input Number", inputTextFieldAccessibilityTitle: "Text Field", choiceSetTickBoxTicked: "Ticked", choiceSetTickBoxUnticked: "Unticked", choiceSetRadioButtonSelected: "Selectd", datePickerFieldAccessibilityRoleDescription: "Date Picker", timePickerFieldAccessibilityRoleDescription: "Time Picker", datePickerButtonAccessibilityTitle: "Date Picker Button", timePickerButtonAccessibilityTitle: "Time Picker Button", clearButtonAccessibilityTitle: "Clear Button")

    let choiceSetCompactAccessibilityRoleDescriptor: String
    let inputNumberAccessibilityTitle: String
    let inputTextFieldAccessibilityTitle: String
    let choiceSetTickBoxTicked: String
    let choiceSetTickBoxUnticked: String
    let choiceSetRadioButtonSelected: String
    let datePickerFieldAccessibilityRoleDescription: String
    let timePickerFieldAccessibilityRoleDescription: String
    let datePickerButtonAccessibilityTitle: String
    let timePickerButtonAccessibilityTitle: String
    let clearButtonAccessibilityTitle: String

    public init(choiceSetCompactAccessibilityRoleDescriptor: String, inputNumberAccessibilityTitle: String, inputTextFieldAccessibilityTitle: String, choiceSetTickBoxTicked: String, choiceSetTickBoxUnticked: String, choiceSetRadioButtonSelected: String, datePickerFieldAccessibilityRoleDescription: String, timePickerFieldAccessibilityRoleDescription: String, datePickerButtonAccessibilityTitle: String, timePickerButtonAccessibilityTitle: String, clearButtonAccessibilityTitle: String) {
        self.choiceSetCompactAccessibilityRoleDescriptor = choiceSetCompactAccessibilityRoleDescriptor
        self.inputNumberAccessibilityTitle = inputNumberAccessibilityTitle
        self.inputTextFieldAccessibilityTitle = inputTextFieldAccessibilityTitle
        self.choiceSetTickBoxTicked = choiceSetTickBoxTicked
        self.choiceSetTickBoxUnticked = choiceSetTickBoxUnticked
        self.choiceSetRadioButtonSelected = choiceSetRadioButtonSelected
        self.datePickerFieldAccessibilityRoleDescription = datePickerFieldAccessibilityRoleDescription
        self.timePickerFieldAccessibilityRoleDescription = timePickerFieldAccessibilityRoleDescription
        self.datePickerButtonAccessibilityTitle = datePickerButtonAccessibilityTitle
        self.timePickerButtonAccessibilityTitle = timePickerButtonAccessibilityTitle
        self.clearButtonAccessibilityTitle = clearButtonAccessibilityTitle
    }
}
