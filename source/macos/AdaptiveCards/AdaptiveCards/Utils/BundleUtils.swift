import AppKit

let bundleIdentifier = "com.test.test.AdaptiveCards"

class BundleUtils {
    static func getImage(_ imageName: String) -> NSImage? {
        let index = imageName.lastIndex(of: ".") ?? imageName.endIndex
        let fileType = String(imageName[imageName.index(after: index)...])
        let name = String(imageName[...imageName.index(before: index)])
        guard let bundle = Bundle(identifier: bundleIdentifier),
              let path = bundle.path(forResource: name, ofType: fileType) else {
            logError("Image Not Found")
            return nil
        }
        return NSImage(byReferencing: URL(fileURLWithPath: path))
    }
    
    static func loadNib(_ nibName: String, _ objectName: NSView) {
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            logError("Bundle is nil")
            return
        }
        bundle.loadNibNamed(nibName, owner: objectName, topLevelObjects: nil)
    }
}
