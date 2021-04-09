import AdaptiveCards
import Cocoa

extension NSColor {
    static func color(from hexString: String) -> NSColor? {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        guard hexString.count == 6 || hexString.count == 8 else {
            print("Not valid HexCode: \(hexString)")
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
                               blue: CGFloat((rgbValue & 0x000000FF)) / 255.0,
                               alpha: CGFloat(rgbValue & 0xFF000000) / 255.0)
        
        default:
            print("Not valid HexCode: \(hexString)")
            return nil
        }
    }
}

struct Constants {
    static let blueColorCode = "#007EA8"
    static let darkBlueColorCode = "#0A5E7D"
    
    static let greenColorCode = "#1B8728"
    static let darkGreenColorCode = "#196323"
    
    static let redColorCode = "#D93829"
    static let darkRedColorCode = "#A12C23"
    
    static let grayColorCode = "#E6E8E8"
    static let darkGrayColorCode = "#B4B6B8"
    
    static let darkThemePrimary = "#07C1F5"
    static let darkThemePressed = "#0A5E7D"
}
