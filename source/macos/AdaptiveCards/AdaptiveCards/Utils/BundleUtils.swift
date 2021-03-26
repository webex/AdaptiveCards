import AppKit

class BundleUtils {
    static let bundleIdentifier = "com.test.test.AdaptiveCards"
    
    static func getImage(_ imageName: String, _ fileType: String) -> NSImage? {
        guard let bundle = Bundle(identifier: bundleIdentifier),
              let path = bundle.path(forResource: imageName, ofType: fileType) else {
            logError("Image Not Found")
            return nil
        }
        return NSImage(byReferencing: URL(fileURLWithPath: path))
    }
    
    static func loadNibNamed(_ nibName: String, _ owner: NSView) {
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            logError("Bundle is nil")
            return
        }
        bundle.loadNibNamed(nibName, owner: owner, topLevelObjects: nil)
    }
}
