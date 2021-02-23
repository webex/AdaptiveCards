import AdaptiveCards_bridge
import AppKit

class ACRFactSetElement: NSView {
    // Initialise the outlets
    @IBOutlet var contentView: NSView!
    @IBOutlet var labelText: NSTextField!
    @IBOutlet var valueText: NSTextField!
    @IBOutlet var horizontalLine: NSBox!
    @IBOutlet var verticalLine: NSBox!
    
    let hostConfig = ACSHostConfig()
    
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
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        labelText.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelText.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor).isActive = true
        labelText.trailingAnchor.constraint(equalTo: verticalLine.leadingAnchor).isActive = true
        // This property enables us to wrap and increase the window size to fit text
//        labelText.maximumNumberOfLines = 0
        labelText.setContentCompressionResistancePriority(.required, for: .vertical)
//        labelText.setContentCompressionResistancePriority(.required, for: .horizontal)
//        labelText.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        labelText.cell?.wraps = true
//        labelText.cell?.usesSingleLineMode = false
//        labelText.cell?.isScrollable = false
//        labelText.lineBreakMode = .byWordWrapping

        valueText.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor).isActive = true
        valueText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueText.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor).isActive = true
        valueText.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        // Similar to labelText for wrapping
//        valueText.maximumNumberOfLines = 0
        valueText.setContentCompressionResistancePriority(.required, for: .vertical)
//        valueText.cell?.wraps = true
//        valueText.cell?.usesSingleLineMode = false
//        valueText.cell?.isScrollable = false
        valueText.lineBreakMode = .byWordWrapping
        
        verticalLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        verticalLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
        verticalLine.isTransparent = true
        
        horizontalLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        horizontalLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        horizontalLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalLine.isTransparent = true
        
//        labelText.widthAnchor.constraint(equalTo: valueText.widthAnchor).isActive = true
        valueText.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2).isActive = true
        
        // Customize the look to add bold for label etc
        labelText.alignment = .natural
        valueText.alignment = .natural
    }
    
    func setLabel( string: String?) {
        let randomString = NSMutableAttributedString(string: string ?? "")
        randomString.addAttributes([.font: NSFont.boldSystemFont(ofSize: 12 )], range: NSRange(location: 0, length: randomString.length))
        labelText.attributedStringValue = randomString
//        labelText.stringValue = string ?? ""
    }
    
    func setValue( string: String?) {
        valueText.stringValue = string ?? ""
    }
}
