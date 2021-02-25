import AdaptiveCards_bridge
import AppKit

class ACRFactSetElement: NSView {
    // Initialise the outlets
    @IBOutlet var contentView: NSView!
    @IBOutlet var labelText: NSTextField!
    @IBOutlet var valueText: NSTextField!
//    @IBOutlet var horizontalLine: NSBox!
//    @IBOutlet var verticalLine: NSBox!
    
    let hostConfig = ACSHostConfig()
    var titleAbsent: Bool = false
    
    init() {
        super.init(frame: .zero)
        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
            logError("Bundle is nil")
            return
        }
        bundle.loadNibNamed("ACRFactSetElement", owner: self, topLevelObjects: nil)
        setupViews()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
    }
    
    private func setupConstaints() {
        // TranslateAutoresizingMaskIntoConstaints as false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        labelText.translatesAutoresizingMaskIntoConstraints = false
        valueText.translatesAutoresizingMaskIntoConstraints = false
//        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
//        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        labelText.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        labelText.trailingAnchor.constraint(equalTo: valueText.leadingAnchor).isActive = true
        
        // Try autolayout constraint
//        contentView.autoresizingMask = .width
        labelText.trailingAnchor.constraint(equalTo: valueText.leadingAnchor, constant: -10).isActive = true
        // This property enables us to wrap and increase the window size to fit text
//        labelText.maximumNumberOfLines = 0
        labelText.setContentCompressionResistancePriority(.required, for: .vertical)
//        labelText.setContentHuggingPriority(.required, for: .horizontal)
        // TODO: Make this Dynamic
        labelText.font = NSFont.boldSystemFont(ofSize: 12)
//        labelText.setContentCompressionResistancePriority(.required, for: .horizontal)
//        labelText.setContentHuggingPriority(.init(1), for: .horizontal)
//        labelText.cell?.wraps = true
//        labelText.cell?.usesSingleLineMode = false
//        labelText.cell?.isScrollable = false
//        labelText.lineBreakMode = .byWordWrapping

//        valueText.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor).isActive = true
        valueText.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        valueText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        valueText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        // Similar to labelText for wrapping
//        valueText.maximumNumberOfLines = 0
        valueText.setContentCompressionResistancePriority(.required, for: .vertical)
//        valueText.setContentCompressionResistancePriority(.required, for: .horizontal)
//        valueText.cell?.wraps = true
//        valueText.cell?.usesSingleLineMode = false
//        valueText.cell?.isScrollable = false
//        valueText.lineBreakMode = .byWordWrapping
        
//        verticalLine.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        verticalLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        verticalLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        verticalLine.isTransparent = true
        
//        horizontalLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        horizontalLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        horizontalLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        horizontalLine.isTransparent = true
        
//        labelText.widthAnchor.constraint(equalTo: valueText.widthAnchor, constant: -10).isActive = true
        // Do this to fix allignment when title is nil
        // This line
        
//        labelText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
//        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
//        valueText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
//        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
//        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        
//        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
//        valueText.preferredMaxLayoutWidth = contentView.widthAnchor
//        contentView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        
        // Customize the look to add bold for label etc
        labelText.alignment = .left
        valueText.alignment = .left
    }
    
    func setLabel( string: String?) {
//        let randomString = NSMutableAttributedString(string: string ?? "")
//        randomString.addAttributes([.font: NSFont.boldSystemFont(ofSize: 12 )], range: NSRange(location: 0, length: randomString.length))
        labelText.stringValue = string ?? ""
//        labelText.stringValue = string ?? ""
    }
    
    public func setValue( string: String?) {
        valueText.stringValue = string ?? ""
    }
    
    func titleIsEmpty() {
//        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.01).isActive = true
        labelText.isHidden = true
        valueText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
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
// class ACRFactSetStackView: NSStackView {
//    override func viewDidMoveToSuperview() {
//        super.viewDidMoveToSuperview()
//        // Should look for better solution
//        guard let superview = superview else { return }
//        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
//    }
// }
