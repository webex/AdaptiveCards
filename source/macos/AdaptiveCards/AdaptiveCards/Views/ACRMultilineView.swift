import AdaptiveCards_bridge
import AppKit

class ACRMultilineView: NSView, NSTextViewDelegate {
    @IBOutlet var contentView: NSView!
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var textView: ACRTextView!
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.borderType = NSBorderType.bezelBorder
        scrollView.autohidesScrollers = true
        textView.delegate = self
    }
    
    fileprivate var placeholderAttrString: NSAttributedString?
    var maxLen: Int = 0
    
    func setPlaceholder(placeholder: String) {
        let placeholderValue = NSMutableAttributedString(string: placeholder)
        placeholderValue.addAttributes([.foregroundColor: NSColor.placeholderTextColor], range: NSRange(location: 0, length: placeholderValue.length))
        textView.placeholderAttrString = placeholderValue
    }
    
    func setValue(value: String, maximumLen: NSNumber?) {
        var attributedValue = NSMutableAttributedString(string: value)
        let maxCharLen = Int(truncating: maximumLen ?? 0)
        if maxCharLen > 0, attributedValue.string.count > maxCharLen {
            attributedValue = NSMutableAttributedString(string: String(attributedValue.string.dropLast(attributedValue.string.count - maxCharLen)))
        }
        textView.textStorage?.setAttributedString(attributedValue)
    }
    
    func textDidChange(_ notification: Notification) {
            guard maxLen > 0  else { return } // maxLen returns 0 if propery not set
            guard let textView = notification.object as? NSTextView, textView.string.count > maxLen else { return }
            textView.string = String(textView.string.dropLast())
            if textView.string.count > maxLen {
                textView.string = String(textView.string.dropLast(textView.string.count - maxLen))
            }
    }
}
