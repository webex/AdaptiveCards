// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class ACSTextStyleConfig: NSObject {

    public private(set) var weight: ACSTextWeight
    public private(set) var size: ACSTextSize
    public private(set) var isSubtle: Bool
    public private(set) var color: ACSForegroundColor
    public private(set) var fontType: ACSFontType

    public init(
        weight: ACSTextWeight,
        size: ACSTextSize,
        isSubtle: Bool,
        color: ACSForegroundColor,
        fontType: ACSFontType)
    {
        self.weight = weight
        self.size = size
        self.isSubtle = isSubtle
        self.color = color
        self.fontType = fontType
        
    }
}
