import AdaptiveCards_bridge
import AppKit

struct ACRBleedValue {
    let top: Bool
    let bottom: Bool
    let leading: Bool
    let trailing: Bool
}

struct ACRBleedDirection: OptionSet {
    let rawValue: UInt
    
    static let ACRBleedRestricted = ACRBleedDirection(rawValue: 0 << 0)
    static let ACRBleedToLeadingEdge = ACRBleedDirection(rawValue: 1 << 0)
    static let ACRBleedToTrailingEdge = ACRBleedDirection(rawValue: 1 << 1)
    static let ACRBleedToTopEdge = ACRBleedDirection(rawValue: 1 << 2)
    static let ACRBleedToBottomEdge = ACRBleedDirection(rawValue: 1 << 3)
    static let ACRBleedToAll: ACRBleedDirection = [.ACRBleedToBottomEdge, .ACRBleedToLeadingEdge, .ACRBleedToTrailingEdge, .ACRBleedToTopEdge]
    
    func getBleedValues() -> ACRBleedValue {
        let top = (self.rawValue & ACRBleedDirection.ACRBleedToTopEdge.rawValue) != 0
        let leading = (self.rawValue & ACRBleedDirection.ACRBleedToLeadingEdge.rawValue) != 0
        let trailing = (self.rawValue & ACRBleedDirection.ACRBleedToTrailingEdge.rawValue) != 0
        let bottom = (self.rawValue & ACRBleedDirection.ACRBleedToBottomEdge.rawValue) != 0
        return ACRBleedValue(top: top, bottom: bottom, leading: leading, trailing: trailing)
    }
}
