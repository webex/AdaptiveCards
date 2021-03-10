import AdaptiveCards_bridge
import AppKit

class ACRFactTextField: NSView {
    @IBOutlet private var contentView: NSView!
    @IBOutlet private var labelTextField: NSTextField!
    var hostConfig: ACSHostConfig?
    
    init(hostConfig: ACSHostConfig) {
        super.init(frame: .zero)
        self.hostConfig = hostConfig
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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        labelTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        labelTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        labelTextField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        labelTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        labelTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        labelTextField.alignment = .left
    }
    
    func setupTitle() {
        // TODO: Make it get all properties from host config
        labelTextField.font = NSFont.boldSystemFont(ofSize: 12)
    }
    
    var isEmpty: Bool {
        return labelTextField.stringValue.isEmpty
    }
    
    var textColor: NSColor {
        get { return labelTextField.textColor ?? .black }
        set { labelTextField.textColor = newValue }
    }
    
//    var textValue: String? {
//        get { return labelTextField.stringValue }
//        set {
//            labelTextField.stringValue = newValue ?? ""
//        }
//    }
    var textValue: NSAttributedString? {
        get { return labelTextField.attributedStringValue }
        set {
            labelTextField.attributedStringValue = newValue ?? NSAttributedString(string: "")
        }
    }
//            let markdownResult = BridgeTextUtils.processText(from: labelTextField, hostConfig: hostConfig)
//            let attributedString: NSMutableAttributedString
//            if markdownResult.isHTML, let htmlData = markdownResult.htmlData {
//                do {
//                    attributedString = try NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//                    // Delete trailing newline character
//                    attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
//                    textView.isSelectable = true
//                } catch {
//                    attributedString = NSMutableAttributedString(string: markdownResult.parsedString)
//                }
//            } else {
//                attributedString = NSMutableAttributedString(string: markdownResult.parsedString)
//                // Delete <p> and </p>
//                attributedString.deleteCharacters(in: NSRange(location: 0, length: 3))
//                attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 4, length: 4))
//            }
//        }
//    }
}

// MARK: Class required for Horizontal Stack View
class ACRFactSetView: NSView {
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
