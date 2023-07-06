import AdaptiveCards_bridge
import AppKit

enum ColumnWidth: Equatable {
    case stretch, auto, fixed(_ width: CGFloat), weighted(_ weight: Int)
    
    var isWeighted: Bool {
        switch self {
        case .weighted: return true
        default: return false
        }
    }
    
    var huggingPriority: NSLayoutConstraint.Priority {
        switch self {
        case .auto: return .init(252)
        case .stretch: return .init(249)
        default: return .defaultLow
        }
    }
    
    init(columnWidth: String?, pixelWidth: NSNumber?) {
        if let width = pixelWidth, let float = CGFloat(exactly: width), float > 0 {
            self = .fixed(float)
            return
        }
        if let width = columnWidth, let weight = Int(width) {
            self = .weighted(weight)
            return
        }
        self = columnWidth == "auto" ? .auto : .stretch
    }
    
    static func == (lhs: ColumnWidth, rhs: ColumnWidth) -> Bool {
        switch (lhs, rhs) {
        case (.stretch, .stretch),
             (.auto, .auto): return true
        case let (.fixed(widthA), .fixed(widthB)): return widthA == widthB
        case let (.weighted(weightA), .weighted(weightB)): return weightA == weightB
        default: return false
        }
    }
}

class ACRColumnView: ACRContentStackView {
    enum Constants {
        static let minWidth: CGFloat = 30
    }
    
    private lazy var widthConstraint = widthAnchor.constraint(equalToConstant: Constants.minWidth)
    private (set) lazy var backgroundImageViewBottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    private (set) lazy var backgroundImageViewTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: topAnchor)
    private (set) lazy var backgroundImageViewLeadingConstraint = backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
    private (set) lazy var backgroundImageViewTrailingConstraint = backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
    
    private (set) var columnWidth: ColumnWidth = .weighted(1)
    private (set) lazy var minWidthConstraint: NSLayoutConstraint = {
        let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minWidth)
        constraint.priority = .defaultHigh
        return constraint
    }()
    
    private (set) lazy var backgroundImageView: ACRBackgroundImageView = {
        let view = ACRBackgroundImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var numberOfColumns: Int?
    
    // AccessibleFocusView property
    override var validKeyView: NSView? {
        get {
            return self
        }
        set { }
    }
    
    override func addArrangedSubview(_ subview: NSView) {
        // Activate min Width constraint only if column has a non-image subview
        // Because - column can be empty                        -> should have zero content size
        //         - image can have dimensions less than 30 pts -> should match image content size
        //         - spacingView should be ignored
        //              ^ They're invalid without any other view in the stack
        func isIntrinsicView(_ view: NSView) -> Bool {
            if let contentStackView = view as? ACRContentStackView {
                return contentStackView.arrangedSubviews.allSatisfy { isIntrinsicView($0) }
            }
            return view is ACRImageWrappingView || view is SpacingView
        }
        
        if !isIntrinsicView(subview) {
            minWidthConstraint.isActive = true
        }
        
        manageWidth(of: subview)
        super.addArrangedSubview(subview)
    }
    
    override func setupViews() {
        addSubview(backgroundImageView)
        super.setupViews()
    }
    
    override func setupInternalKeyviews() {
        self.nextKeyView = self.exitView?.validKeyView
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        backgroundImageViewTopConstraint.isActive = true
        backgroundImageViewLeadingConstraint.isActive = true
        backgroundImageViewTrailingConstraint.isActive = true
        backgroundImageViewBottomConstraint.isActive = true
    }
    
    override func anchorBottomConstraint(with anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        super.anchorBottomConstraint(with: anchor)
        backgroundImageViewBottomConstraint.isActive = false
        backgroundImageViewBottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: anchor)
        backgroundImageViewBottomConstraint.isActive = true
    }
    
    override func configureLayoutAndVisibility(minHeight: NSNumber?) {
        super.configureLayoutAndVisibility(minHeight: minHeight)
        setStretchableHeight()
    }
    
    func setupBackgroundImageProperties(_ properties: ACSBackgroundImage) {
        backgroundImageView.isHidden = false
        backgroundImageView.fillMode = properties.getFillMode()
        backgroundImageView.horizontalAlignment = properties.getHorizontalAlignment()
        backgroundImageView.verticalAlignment = properties.getVerticalAlignment()
        heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
    
    func configureColumnProperties(for view: NSView) {
        if view is ACRDateField || view is ACRSingleLineInputTextView || view is ACRMultilineInputTextView || view is ACRNumericTextField {
            minWidthConstraint.constant = 100
            if let numberOfColumns = numberOfColumns, numberOfColumns > 3 {
                minWidthConstraint.constant = 60
            }
        }
        manageWidth(of: view)
    }
    
    func setWidth(_ width: ColumnWidth) {
        columnWidth = width
        manageWidth(of: self)
        manageWidth(of: stackView)
    }
    
    func setNumberOfColumns(_ value: Int?) {
        self.numberOfColumns = value
    }
    
    private func manageWidth(of view: NSView) {
        switch columnWidth {
        case .fixed(let widthSize):
            widthConstraint.constant = widthSize
            widthConstraint.isActive = true
            
        case .auto:
            view.setContentHuggingPriority(columnWidth.huggingPriority, for: .horizontal)
            view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            widthConstraint.isActive = false
            
        case .stretch:
            view.setContentHuggingPriority(columnWidth.huggingPriority, for: .horizontal)
            view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            widthConstraint.isActive = false
            
        case .weighted:
            widthConstraint.isActive = false
        }
    }
    
    func bleedBackgroundImage(direction: ACRBleedValue, with padding: CGFloat) {
        backgroundImageViewTopConstraint.constant = direction.top ? -padding : 0
        backgroundImageViewTrailingConstraint.constant = direction.trailing ? padding : 0
        backgroundImageViewLeadingConstraint.constant = direction.leading ? -padding : 0
        backgroundImageViewBottomConstraint.constant = direction.bottom ?  padding : 0
    }
    
    override func setBleedViewConstraint(direction: ACRBleedValue, with padding: CGFloat) {
        // adding this below collectionView backgroundImage view
        addSubview(bleedView, positioned: .below, relativeTo: self.backgroundImageView)
        super.setBleedViewConstraint(direction: direction, with: padding)
    }
}
