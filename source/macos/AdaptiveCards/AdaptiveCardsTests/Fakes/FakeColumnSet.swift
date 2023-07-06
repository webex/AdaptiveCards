import AdaptiveCards_bridge

class FakeColumnSet: ACSColumnSet {
    var columns: [ACSColumn] = []
    var style: ACSContainerStyle = .default
    var id: String? = ""
    var selectAction: ACSBaseActionElement?
    var horizontalAlignment: ACSHorizontalAlignment = .left
    var padding: Bool = false
    var verticalContentAlignment: ACSVerticalContentAlignment = .top
    var minHeight: NSNumber?
    var height: ACSHeightType = .auto
    var type: ACSCardElementType = .columnSet
    var bleed: Bool = false
    var separator: Bool = false
    var visible: Bool = true
    
    override func getType() -> ACSCardElementType {
        return type
    }
    
    override func getColumns() -> [ACSColumn] {
        return columns
    }
    
    override func getStyle() -> ACSContainerStyle {
        return style
    }
    
    override func setStyle(_ value: ACSContainerStyle) {
        style = value
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func getSelectAction() -> ACSBaseActionElement? {
        return selectAction
    }
    
    override func getVerticalContentAlignment() -> ACSVerticalContentAlignment {
        return verticalContentAlignment
    }
    
    override func setVerticalContentAlignment(_ value: ACSVerticalContentAlignment) {
        verticalContentAlignment = value
    }
    
    override func getHorizontalAlignment() -> ACSHorizontalAlignment {
        return horizontalAlignment
    }
    
    override func setHorizontalAlignment(_ value: ACSHorizontalAlignment) {
        horizontalAlignment = value
    }
    
    override func getPadding() -> Bool {
        return padding
    }
    
    override func setPadding(_ value: Bool) {
        padding = value
    }
    
    override func getMinHeight() -> NSNumber? {
        return minHeight
    }
    
    override func setMinHeight(_ value: NSNumber) {
        minHeight = value
    }
    
    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
    
    open override func getBleed() -> Bool {
        return bleed
    }
    
    open override func setBleed(_ value: Bool) {
        bleed = value
    }
    
    override func getCanBleed() -> Bool {
        return true
    }
    
    override func getBleedDirection() -> ACSContainerBleedDirection {
        return .bleedAll
    }
    
    override func getSeparator() -> Bool {
        return separator
    }
    
    override func getIsVisible() -> Bool {
        return visible
    }
    
    override func getBackgroundImage() -> ACSBackgroundImage? {
        return nil
    }
}

extension FakeColumnSet {
    static func make(columns: [ACSColumn] = [], style: ACSContainerStyle = .default, selectAction: ACSBaseActionElement? = nil, horizontalAlignment: ACSHorizontalAlignment = .left, bleed: Bool = false, padding: Bool = false, heightType: ACSHeightType = .auto) -> FakeColumnSet {
       let fakeColumnSet = FakeColumnSet()
        fakeColumnSet.columns = columns
        fakeColumnSet.style = style
        fakeColumnSet.selectAction = selectAction
        fakeColumnSet.horizontalAlignment = horizontalAlignment
        fakeColumnSet.padding = padding
        fakeColumnSet.height = heightType
        fakeColumnSet.bleed = bleed
        return fakeColumnSet
    }
}
