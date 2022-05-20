import AdaptiveCards_bridge
import AppKit

// MARK: Class required for Horizontal Stack View
class ACRFactSetView: NSView {
    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("ACRFactSetView should not be initialised with a coder")
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
