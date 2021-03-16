import AdaptiveCards_bridge
import AppKit

class ACRActionSetView: NSView {
    private lazy var stackview: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var frameWidth: CGFloat = 0
    var totalWidth: CGFloat = 0
    var actions: [NSView] = []
    var padding: CGFloat = 0
    var actionsToRender = 0
    var maxFrameWidth: CGFloat = 0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(stackview)
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func customLayout() {
        print("@running custom layout")
        // first empty the stackview and remove all the views
        removeElements()
        var accumulatedWidth: CGFloat = 0
        
        // new child stackview for horizontal orientation
        var curview = NSStackView()
        curview.translatesAutoresizingMaskIntoConstraints = false
        curview.spacing = padding
        
        // adding new child stackview to stackview and the parent stackview will align child stackview vertically
        stackview.addArrangedSubview(curview)
        stackview.orientation = .vertical
        stackview.alignment = .leading
        
        for view in actions {
            accumulatedWidth += view.intrinsicContentSize.width
            accumulatedWidth += padding
            totalWidth = frameWidth
            if accumulatedWidth > frameWidth {
                let newStackView: NSStackView = {
                    let view = NSStackView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                curview = newStackView
                curview.addArrangedSubview(view)
                curview.spacing = padding
                accumulatedWidth = 0
                accumulatedWidth += view.intrinsicContentSize.width
                accumulatedWidth += padding
                stackview.addArrangedSubview(newStackView)
            } else {
                curview.addArrangedSubview(view)
            }
        }
    }
    
    func removeElements() {
        for view in stackview.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    override func layout() {
        super.layout()
        frameWidth = frame.width
        if orientation == .horizontal, totalWidth > frameWidth, totalWidth > maxFrameWidth, frameWidth != 0 {
            maxFrameWidth = frameWidth
            customLayout()
        }
    }
    var orientation: NSUserInterfaceLayoutOrientation {
        get { stackview.orientation }
        set {
            stackview.orientation = newValue
        }
    }
    
    var alignment: NSLayoutConstraint.Attribute {
        get { stackview.alignment }
        set {
            stackview.alignment = newValue
        }
    }
    
     var spacing: CGFloat {
        get { stackview.spacing }
        set {
            stackview.spacing = newValue
        }
    }
    
    func addArrangedSubView(_ view: NSView) {
        stackview.addArrangedSubview(view)
    }
}
