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
    
    override func layout() {
        super.layout()
        recalculateKeyViewLoop()
    }
    
    private func recalculateKeyViewLoop() {
        if let titleStack = self.subviews.first, let valueStack = self.subviews.last {
            // This will begin functioning once we get the default keyview loop views. then we will alter according to our needs. otherwise default may override the loop sequence. we add nil scenario due to avoid multiple time execution.
            guard titleStack.subviews.first?.nextKeyView != nil, titleStack.subviews.first?.nextKeyView != valueStack.subviews.first else {
                return
            }
            weak var lastKeyView: NSView?
            for index in 0..<titleStack.subviews.count {
                if let lastKeyView = lastKeyView {
                    lastKeyView.nextKeyView = titleStack.subviews[index]
                }
                titleStack.subviews[index].nextKeyView = valueStack.subviews[index]
                lastKeyView = valueStack.subviews[index]
            }
        }
    }
}
