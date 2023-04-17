import AdaptiveCards_bridge
import AppKit

// MARK: Class required for Horizontal Stack View
class ACRFactSetView: NSView {
    private weak var lastRefKeyView: NSView?
    
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
    
    override func layout() {
        super.layout()
        recalculateKeyViewLoop()
    }
    
    private func recalculateKeyViewLoop() {
        weak var lastKeyView: NSView?
        if let titleView = self.subviews.first, let valueView = self.subviews.last {
            // This will begin functioning once we get the default keyview loop views. then we will alter according to our needs. otherwise default may override the loop sequence. we add nil scenario due to avoid multiple time execution.
            guard titleView.subviews.first?.nextKeyView != nil, lastRefKeyView != titleView.subviews.first?.nextKeyView else {
                return
            }
            self.lastRefKeyView = valueView.subviews.first
            for index in 0..<titleView.subviews.count {
                if let lastKeyView = lastKeyView {
                    lastKeyView.nextKeyView = titleView.subviews[index]
                }
                titleView.subviews[index].nextKeyView = valueView.subviews[index]
                lastKeyView = valueView.subviews[index]
            }
        }
    }
}
