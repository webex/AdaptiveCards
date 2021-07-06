import AdaptiveCards_bridge
import AppKit

class ACRActionSetView: NSView {
    private lazy var stackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = orientation
        view.spacing = spacing
        view.alignment = alignment
        return view
    }()
    
    private let actions: [NSView]
    private let orientation: NSUserInterfaceLayoutOrientation
    private let alignment: NSLayoutConstraint.Attribute
    private let spacing: CGFloat
    
    init(actions: [NSView], orientation: NSUserInterfaceLayoutOrientation, alignment: NSLayoutConstraint.Attribute, spacing: CGFloat) {
        self.actions = actions
        self.orientation = orientation
        self.alignment = alignment
        self.spacing = spacing
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        self.actions = []
        self.orientation = .vertical
        self.alignment = .leading
        self.spacing = 8
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        wantsLayer = true
        layer = NoClippingLayer()
        addSubview(stackView)
        setupConstraints()
        arrangeElementsIfNeeded()
    }
    
    private var initialLayoutDone = false
    private var previousWidth: CGFloat?
    override func layout() {
        super.layout()
        guard window != nil, bounds.width > 0, !initialLayoutDone, previousWidth != bounds.width else { return }
        arrangeElementsIfNeeded()
        initialLayoutDone = true
        previousWidth = bounds.width
    }
    
    private func setupConstraints() {
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func removeElements() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    private func arrangeElementsIfNeeded() {
        switch orientation {
        case .horizontal:
            layoutHorizontally()
        case .vertical:
            layoutVertically()
            initialLayoutDone = true
        @unknown default:
            layoutVertically()
            initialLayoutDone = true
        }
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let view = superview else { return }
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func layoutVertically() {
        removeElements()
        actions.forEach {
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
    
    private func layoutHorizontally() {
        // first empty the stackview and remove all the views
        removeElements()
        var accumulatedWidth: CGFloat = 0
        
        // new child stackview for horizontal orientation
        var curview = NSStackView()
        curview.translatesAutoresizingMaskIntoConstraints = false
        curview.spacing = spacing
        
        // adding new child stackview to parent stackview and the parent stackview will align child stackview vertically
        stackView.addArrangedSubview(curview)
        stackView.orientation = .vertical
        let gravityArea: NSStackView.Gravity = stackView.alignment == .centerY ? .center: (stackView.alignment == .trailing ? .trailing: .leading)
        for view in actions {
            accumulatedWidth += view.intrinsicContentSize.width
            if accumulatedWidth > bounds.width {
                let newStackView: NSStackView = {
                    let view = NSStackView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                curview = newStackView
                curview.orientation = .horizontal
                curview.addView(view, in: gravityArea)
                curview.spacing = spacing
                accumulatedWidth = 0
                accumulatedWidth += view.intrinsicContentSize.width
                accumulatedWidth += spacing
                stackView.addArrangedSubview(curview)
            } else {
                curview.addView(view, in: gravityArea)
                accumulatedWidth += spacing
            }
        }
    }
}
