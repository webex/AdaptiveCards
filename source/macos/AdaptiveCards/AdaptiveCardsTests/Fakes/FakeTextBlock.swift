import AdaptiveCards_bridge

class FakeTextBlock: ACSTextBlock {
    public var text: String?
    public var textForDateParsing: ACSDateTimePreparser?
    public var textSize: ACSTextSize = .default
    public var textWeight: ACSTextWeight = .default
    public var fontType: ACSFontType = .default
    public var textColor: ACSForegroundColor = .default
    public var wrap: Bool = false
    public var isSubtle: Bool = false
    public var maxLines: NSNumber = 0
    public var horizontalAlignment: ACSHorizontalAlignment = .left
    public var language: String?
    public var id: String? = ""
    public var separator: Bool = false
    public var isVisible: Bool = true
    public var spacing: ACSSpacing = .default
    public var height: ACSHeightType = .auto

    open override func getText() -> String? {
        return text
    }

    open override func setText(_ value: String) {
        text = value
    }

    open override func getTextForDateParsing() -> ACSDateTimePreparser? {
        return textForDateParsing
    }

    open override func getTextSize() -> ACSTextSize {
        return textSize
    }

    open override func setTextSize(_ value: ACSTextSize) {
        textSize = value
    }

    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
    
    open override func getTextWeight() -> ACSTextWeight {
        return textWeight
    }

    open override func setTextWeight(_ value: ACSTextWeight) {
        textWeight = value
    }

    open override func getFontType() -> ACSFontType {
        return fontType
    }

    open override func setFontType(_ value: ACSFontType) {
        fontType = value
    }

    open override func getTextColor() -> ACSForegroundColor {
        return textColor
    }

    open override func setTextColor(_ value: ACSForegroundColor) {
        textColor = value
    }

    open override func getWrap() -> Bool {
        return wrap
    }

    open override func setWrap(_ value: Bool) {
        wrap = value
    }

    open override func getIsSubtle() -> Bool {
        return isSubtle
    }

    open override func setIsSubtle(_ value: Bool) {
        isSubtle = value
    }

    open override func getMaxLines() -> NSNumber? {
        return maxLines
    }

    open override func setMaxLines(_ value: NSNumber) {
        maxLines = value
    }

    open override func getHorizontalAlignment() -> ACSHorizontalAlignment {
        return horizontalAlignment
    }

    open override func setHorizontalAlignment(_ value: ACSHorizontalAlignment) {
        horizontalAlignment = value
    }

    open override func setLanguage(_ value: String) {
        language = value
    }

    open override func getLanguage() -> String? {
        return language
    }
    
    open override func getType() -> ACSCardElementType {
        return .textBlock
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func getSeparator() -> Bool {
        return separator
    }
    
    override func getIsVisible() -> Bool {
        return isVisible
    }
    
    override func getSpacing() -> ACSSpacing {
        return spacing
    }
}

extension FakeTextBlock {
    static func make(text: String? = "", textForDateParsing: ACSDateTimePreparser? = nil, textSize: ACSTextSize = .default, heightType: ACSHeightType = .auto, textWeight: ACSTextWeight = .default, fontType: ACSFontType = .default, textColor: ACSForegroundColor = .default, wrap: Bool = false, isSubtle: Bool = false, maxLines: NSNumber = 0, horizontalAlignment: ACSHorizontalAlignment = .left, language: String? = "", separator: Bool = false, isVisible: Bool = false, spacing: ACSSpacing = .default) -> FakeTextBlock {
        let fakeTextBlock = FakeTextBlock()
        fakeTextBlock.text = text
        fakeTextBlock.textForDateParsing = textForDateParsing
        fakeTextBlock.textSize = textSize
        fakeTextBlock.textWeight = textWeight
        fakeTextBlock.fontType = fontType
        fakeTextBlock.textColor = textColor
        fakeTextBlock.wrap = wrap
        fakeTextBlock.isSubtle = isSubtle
        fakeTextBlock.maxLines = maxLines
        fakeTextBlock.horizontalAlignment = horizontalAlignment
        fakeTextBlock.language = language
        fakeTextBlock.separator = separator
        fakeTextBlock.spacing = spacing
        fakeTextBlock.isVisible = isVisible
        fakeTextBlock.height = heightType
        return fakeTextBlock
    }
}
