import AdaptiveCards_bridge
import AppKit

extension ACSHostConfig {
    static func getTextBlockAlignment(from horizontalAlignment: ACSHorizontalAlignment) -> NSTextAlignment {
        switch horizontalAlignment {
        case .center: return .center
        case .left: return .left
        case .right: return .right
        @unknown default: return .left
        }
    }
    
    func getBackgroundColor(for containerStyle: ACSContainerStyle) -> NSColor? {
        guard let hexColorCode = getBackgroundColor(containerStyle) else {
            logError("HexColorCode is nil")
            return nil
        }
        return ColorUtils.color(from: hexColorCode)
    }
    
    func getBorderColor(for containerStyle: ACSContainerStyle) -> NSColor? {
        guard let hexColorCode = getBorderColor(containerStyle) else {
            logError("HexColorCode is nil")
            return nil
        }
        return ColorUtils.color(from: hexColorCode)
    }
    
    func getBorderThickness(for containerStyle: ACSContainerStyle) -> CGFloat? {
        guard let thickness = getBorderThickness(containerStyle) else {
            logError("HexColorCode is nil")
            return nil
        }
        return CGFloat(exactly: thickness)
    }
}

class FontUtils {
    private static var notFoundFontFamilies: Set<String> = []
    
    static func getFont(for hostConfig: ACSHostConfig, with textProperties: ACSRichTextElementProperties, attributesFont: NSFont? = nil) -> NSFont {
        var isBolder = false
        var isItalic = false
        let fontWeights = ["UltraLight", "Thin", "Light", "Regular", "Medium", "Semibold", "Bold", "Heavy", "Black"]
        let size = hostConfig.getFontSize(textProperties.getFontType(), size: textProperties.getTextSize())?.intValue ?? 14
        var fontWeight = hostConfig.getFontWeight(textProperties.getFontType(), weight: textProperties.getTextWeight())?.intValue ?? 400
        if fontWeight <= 0 || fontWeight > 900 {
            fontWeight = 400
        }
        fontWeight = (fontWeight - 100) / 100
        let resolvedFontFamily: String?
        if let family = hostConfig.getFontFamily(textProperties.getFontType()) {
            resolvedFontFamily = textProperties.getFontType() == .monospace ? "Courier New" : family
        } else {
            resolvedFontFamily = textProperties.getFontType() == .monospace ? "Courier New" : nil
        }
        // Check If Attributed string has traits
        if let font = attributesFont {
            if font.fontDescriptor.symbolicTraits.contains(.bold) {
                isBolder = true
            }
            if font.fontDescriptor.symbolicTraits.contains(.italic) {
                isItalic = true
            }
        }
        // Check If Text Properties has traits
        if textProperties.getTextWeight() == .bolder {
            isBolder = true
        }
        if textProperties.getItalic() {
            isItalic = true
        }
        guard let fontFamily = resolvedFontFamily, !fontFamily.isEmpty, !notFoundFontFamilies.contains(fontFamily) else {
            // Custom Font family not needed
            return getSystemFont(for: hostConfig, with: textProperties, fontWeight: fontWeight, italic: isItalic, bold: isBolder)
        }
        guard let customFont = NSFont(name: fontFamily, size: CGFloat(size)) else {
            logError("Font with fontFamily '\(fontFamily)' not found. Returning system font.")
            notFoundFontFamilies.insert(fontFamily)
            return getSystemFont(for: hostConfig, with: textProperties, fontWeight: fontWeight, italic: isItalic, bold: isBolder)
        }
        var descriptor = customFont.fontDescriptor
        descriptor.addingAttributes([.face: fontWeights[fontWeight]])
        descriptor = getBoldItalicFontDescriptor(descriptor, italic: isItalic, bold: isBolder)
        guard let finalFont = NSFont(descriptor: descriptor, size: CGFloat(size)) else {
            logError("Font with fontFamily '\(fontFamily)' not found. Returning system font.")
            notFoundFontFamilies.insert(fontFamily)
            return getSystemFont(for: hostConfig, with: textProperties, fontWeight: fontWeight, italic: isItalic, bold: isBolder)
        }
        return finalFont
    }
    
    private static func getBoldItalicFontDescriptor(_ descriptor: NSFontDescriptor, italic: Bool, bold: Bool) -> NSFontDescriptor {
        var symbolicTraits = descriptor.symbolicTraits
        if bold {
            symbolicTraits.insert(.bold)
        }
        if italic {
            symbolicTraits.insert(.italic)
        }
        return descriptor.withSymbolicTraits(symbolicTraits)
    }
    
    private static func getSystemFont(for hostConfig: ACSHostConfig, with textProperties: ACSRichTextElementProperties, fontWeight: Int, italic: Bool, bold: Bool) -> NSFont {
        let fontWeights: [NSFont.Weight] = [.ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
        let size = hostConfig.getFontSize(textProperties.getFontType(), size: textProperties.getTextSize())?.intValue ?? 14
        let systemFont = NSFont.systemFont(ofSize: CGFloat(size), weight: bold ? .bold : fontWeights[fontWeight])
        var fontDescriptor = systemFont.fontDescriptor
        fontDescriptor = getBoldItalicFontDescriptor(fontDescriptor, italic: italic, bold: bold)
        guard let font = NSFont(descriptor: fontDescriptor, size: CGFloat(size)) else {
            logError("Generating System Italic-bold font failed")
            return systemFont
        }
        return font
    }
}

class ColorUtils {
    static func color(from hexString: String) -> NSColor? {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        guard hexString.count == 6 || hexString.count == 8 else {
            logError("Not valid HexCode: \(hexString)")
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        // Need to revisit and validate
        switch hexString.count {
        case 6: return NSColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                               green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                               blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                               alpha: CGFloat(1.0))
            
        case 8: return NSColor(red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                               green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                               blue: CGFloat(rgbValue & 0x000000FF) / 255.0,
                               alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0)
        default:
            logError("Not valid HexCode: \(hexString)")
            return nil
        }
    }
    
    // TODO: Discard these from here
    static func hoverColorOnMouseEnter() -> NSColor {
        if #available(OSX 10.14, *) {
            return .unemphasizedSelectedTextBackgroundColor
        } else {
            return .windowBackgroundColor
        }
    }
    
    static func hoverColorOnMouseExit() -> NSColor {
        return .textBackgroundColor
    }
}

class TextUtils {
    static func getRenderAttributedString(text: String, with hostConfig: ACSHostConfig, renderConfig: RenderConfig, rootView: ACRView, style: ACSContainerStyle) -> NSMutableAttributedString {
        let markdownResult = BridgeTextUtils.process(onRawTextString: text, hostConfig: hostConfig)
        let markdownString = TextUtils.getMarkdownString(for: rootView, with: markdownResult)
        let textProperties = BridgeTextUtils.getRichTextElementProperties(text)
        let attributedString = TextUtils.addFontProperties(attributedString: markdownString, textProperties: textProperties, hostConfig: hostConfig)
        if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: true), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor, .cursor: NSCursor.arrow], range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString
    }
    
    static func getMarkdownString(for view: ACRView, with parserResult: ACSMarkdownParserResult) -> NSMutableAttributedString {
        guard parserResult.isHTML, let attributedString = view.resolveAttributedString(for: parserResult.parsedString) else {
            return getMarkdownString(parserResult: parserResult)
        }
        
        let trimmedString = attributedString.string.trimmingCharacters(in: .newlines)
        let range = (attributedString.string as NSString).range(of: trimmedString)
        
        guard !trimmedString.isEmpty, range.lowerBound > 0, range.upperBound < attributedString.length else {
            return NSMutableAttributedString(attributedString: attributedString)
        }
        return NSMutableAttributedString(attributedString: attributedString.attributedSubstring(from: range))
    }
    
    private static func getMarkdownString(parserResult: ACSMarkdownParserResult) -> NSMutableAttributedString {
        let content: NSMutableAttributedString
        if parserResult.isHTML, let htmlData = parserResult.htmlData {
            do {
                content = try NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
               
                // fix up tabbing, nested tabbing and wrapping
                let attributeStrings = splitString(inputString: content, separatedBy: "\n")
                let singleTabDepth: CGFloat = 28
                let newAttrString = NSMutableAttributedString()
                newAttrString.beginEditing()
                var currentTabCount = 0
                
                for attributeString in attributeStrings {
                    let lineAttrString = NSMutableAttributedString(attributedString: attributeString)
                    let str = attributeString.string
                    if str.starts(with: "\t") {
                        currentTabCount = str.filter({ $0 == "\t" }).count
                        addParagraphStyle(lineAttrString, leftIndent: (singleTabDepth * CGFloat(currentTabCount)))
                    }
                    lineAttrString.append(NSAttributedString(string: "\n"))
                    newAttrString.append(lineAttrString)
                }
                newAttrString.endEditing()
                // Delete trailing newline character
                if !parserResult.parsedString.contains("\n") && newAttrString.length > 0 {
                     newAttrString.deleteCharacters(in: NSRange(location: newAttrString.length - 1, length: 1))
                }
                return newAttrString
            } catch {
                content = NSMutableAttributedString(string: parserResult.parsedString)
            }
        } else {
            content = NSMutableAttributedString(string: parserResult.parsedString)
            // Delete <p> and </p>
            content.deleteCharacters(in: NSRange(location: 0, length: 3))
            content.deleteCharacters(in: NSRange(location: content.length - 4, length: 4))
        }
        return content
    }
    
    static func splitString(inputString: NSAttributedString, separatedBy: String) -> [NSAttributedString] {
        let input = inputString.string
        let separatedInput = input.components(separatedBy: separatedBy)
        var output = [NSAttributedString]()
        var start = 0
        for subString in separatedInput {
            let range = NSRange(location: start, length: subString.utf16.count)
            let attributeString = inputString.attributedSubstring(from: range)
            if attributeString.length > 0 {
                output.append(attributeString)
            }
            start += range.length + separatedBy.count
        }
        return output
    }
    
    static func addParagraphStyle(_ attribString: NSMutableAttributedString, lineSpacing: CGFloat = 4, leftIndent: CGFloat = 0) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.lineHeightMultiple = 1.1
        paraStyle.headIndent = leftIndent
        attribString.addAttributes([.paragraphStyle: paraStyle], range: attribString.fullRange)
    }
    
    static func addFontProperties(attributedString: NSMutableAttributedString, textProperties: ACSRichTextElementProperties, hostConfig: ACSHostConfig) -> NSMutableAttributedString {
        let content = NSMutableAttributedString(attributedString: attributedString)
        attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: .reverse, using: { attributes, range, _ in
            guard let font = attributes[.font] as? NSFont else { return }
            let fontWithProperties = FontUtils.getFont(for: hostConfig, with: textProperties, attributesFont: font)
            let newFont = NSFont(descriptor: fontWithProperties.fontDescriptor, size: fontWithProperties.pointSize)
            content.addAttribute(.font, value: newFont as Any, range: range)
        })
        return content
    }
    
    static func addBoldProperty(attributedString: NSAttributedString, textProperties: ACSRichTextElementProperties, hostConfig: ACSHostConfig) -> NSAttributedString {
        let attributedStringCopy = NSMutableAttributedString(attributedString: attributedString)
        let currentFont = FontUtils.getFont(for: hostConfig, with: textProperties)
        attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: .longestEffectiveRangeNotRequired, using: { attributes, range, _ in
            if (attributes[.font] as? NSFont) != nil {
                guard var editedFont = attributes[.font] as? NSFont else { return }
                if editedFont.fontDescriptor.symbolicTraits.contains(.italic) {
                    editedFont = NSFontManager.shared.convert(currentFont, toHaveTrait: [.boldFontMask, .italicFontMask])
                } else {
                    editedFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .boldFontMask)
                }
                attributedStringCopy.addAttribute(.font, value: editedFont, range: range)
            }
        })
        
        return attributedStringCopy
    }
}

class HostConfigUtils {
    static func getSpacing(_ spacing: ACSSpacing, with hostConfig: ACSHostConfig) -> NSNumber {
        let spacingConfig = hostConfig.getSpacing()
        let spaceAdded: NSNumber
        switch spacing {
        case .default: spaceAdded = spacingConfig?.defaultSpacing ?? 0
        case .none: spaceAdded = 0
        case .small: spaceAdded = spacingConfig?.smallSpacing ?? 3
        case .medium: spaceAdded = spacingConfig?.mediumSpacing ?? 20
        case .large: spaceAdded = spacingConfig?.largeSpacing ?? 30
        case .extraLarge: spaceAdded = spacingConfig?.extraLargeSpacing ?? 40
        case .padding: spaceAdded = spacingConfig?.paddingSpacing ?? 20
        @unknown default:
            logError("Unknown padding!")
            spaceAdded = 0
        }
        return spaceAdded
    }
}

extension NSAttributedString {
    public var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}
