import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let minWindowSize = NSSize(width: 1366, height: 768)
        window = NSWindow(contentRect: NSRect(origin: .zero, size: minWindowSize), styleMask: [.miniaturizable, .closable, .titled, .resizable], backing: .buffered, defer: false)
        window?.title = "ADCMacOSVisualizer"
        window?.minSize = minWindowSize
        window?.center()
        window?.collectionBehavior = [.fullScreenAllowsTiling]
        window?.contentViewController = RootViewController()
        window?.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
