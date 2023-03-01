// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class ACSFactSetTextConfig: ACSTextStyleConfig {

    public private(set) var wrap: Bool
    public private(set) var maxWidth: NSNumber

    public init(
        wrap: Bool,
        maxWidth: NSNumber,
        weight: ACSTextWeight,
        size: ACSTextSize,
        isSubtle: Bool,
        color: ACSForegroundColor,
        fontType: ACSFontType)
    {
        self.wrap = wrap
        self.maxWidth = maxWidth
        super.init(weight: weight, size: size, isSubtle: isSubtle, color: color, fontType: fontType)
    }
}
