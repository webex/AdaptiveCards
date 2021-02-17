import AppKit

class ACRMultilineView: NSView {
    @IBOutlet var contentView: NSView!
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    
    init() {
            super.init(frame: .zero)
            guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
                logError("Bundle is nil")
                return
            }
            bundle.loadNibNamed("ACRMultilineView", owner: self, topLevelObjects: nil)
            setupViews()
            setupConstaints()
        }
    
    private func setupViews() {
            addSubview(contentView)
        }
    
    private func setupConstaints() {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.borderType = .lineBorder
    }
    
    func setPlaceholder(placeholder: String) {
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
        attributedPlaceholder.addAttributes([.foregroundColor: NSColor.lightGray], range: NSRange(location: 0, length: attributedPlaceholder.length))
        textView.textStorage?.setAttributedString(attributedPlaceholder)
        }
    
    func setValue(value: String) {
        let attributedValue = NSMutableAttributedString(string: value)
        textView.textStorage?.setAttributedString(attributedValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
