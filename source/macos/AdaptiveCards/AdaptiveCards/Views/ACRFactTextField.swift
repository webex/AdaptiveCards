import AdaptiveCards_bridge
import AppKit

class ACRFactTextField: NSView {
    @IBOutlet var contentView: NSView!
    @IBOutlet var labelText: NSTextField!
    
    init() {
        super.init(frame: .zero)
        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
            logError("Bundle is nil")
            return
        }
        bundle.loadNibNamed("ACRFactTextField", owner: self, topLevelObjects: nil)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
    }
    
    private func setupConstraints() {
        // TranslateAutoresizingMaskIntoConstaints as false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        labelText.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        labelText.setContentCompressionResistancePriority(.required, for: .vertical)
        labelText.alignment = .left
    }
    
    func setLabel( string: String?) {
        labelText.stringValue = string ?? ""
    }
    
    func titleIsEmpty() {
//        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.01).isActive = true
        labelText.isHidden = true
//        valueText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }
    
    func setTitleWidth(width: NSNumber?) {
        labelText.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(truncating: width ?? 150)).isActive = true
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}

class ACRFactSetStackView: NSStackView {
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
