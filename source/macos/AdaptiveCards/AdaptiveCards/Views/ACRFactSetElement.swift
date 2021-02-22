import AdaptiveCards_bridge
import AppKit

class ACRFactSetElement: NSView {
    @IBOutlet var contentView: NSView!
    @IBOutlet var labelText: NSTextField!
    @IBOutlet var valueText: NSTextField!
    @IBOutlet var horizontalLine: NSBox!
    @IBOutlet var verticalLine: NSBox!
    
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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        labelText.translatesAutoresizingMaskIntoConstraints = false
        valueText.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        contentView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        labelText.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelText.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor).isActive = true
        labelText.trailingAnchor.constraint(equalTo: verticalLine.leadingAnchor).isActive = true
        labelText.maximumNumberOfLines = 0
        labelText.setContentCompressionResistancePriority(.required, for: .vertical)

        valueText.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor).isActive = true
        valueText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueText.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor).isActive = true
        valueText.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        valueText.maximumNumberOfLines = 0
        valueText.setContentCompressionResistancePriority(.required, for: .vertical)
        
        verticalLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        horizontalLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        horizontalLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        horizontalLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        labelText.widthAnchor.constraint(equalTo: valueText.widthAnchor).isActive = true
        labelText.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2).isActive = true
        
        labelText.cell?.wraps = true
        labelText.cell?.usesSingleLineMode = false
        labelText.cell?.isScrollable = false
        labelText.lineBreakMode = .byWordWrapping
//        labelText.preferredMaxLayoutWidth =
//        valueText.preferredMaxLayoutWidth = 100
        
        valueText.cell?.wraps = true
        valueText.cell?.usesSingleLineMode = false
        valueText.cell?.isScrollable = false
        valueText.lineBreakMode = .byWordWrapping
    }
    
    func setLabel( string: String?) {
        labelText.stringValue = string ?? ""
    }
    
    func setValue( string: String?) {
        valueText.stringValue = string ?? ""
    }
}
