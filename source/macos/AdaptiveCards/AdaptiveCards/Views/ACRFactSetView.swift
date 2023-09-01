import AdaptiveCards_bridge
import AppKit

// MARK: Class required for Horizontal Stack View
class ACRFactSetView: NSView {
    private let inputElement: ACSFactSet
    private let config: RenderConfig
    private let hostConfig: ACSHostConfig
    private let style: ACSContainerStyle
    private weak var rootView: ACRView?
    
    private (set) lazy var titleStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private (set) lazy var valueStackView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private var requiredWidth: CGFloat = 0
    var hasLink = false
    
    // AccessibleFocusView property
    weak var exitView: AccessibleFocusView?
    
    init(config: RenderConfig, inputElement: ACSFactSet, hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView) {
        self.inputElement = inputElement
        self.config = config
        self.hostConfig = hostConfig
        self.style = style
        self.rootView = rootView
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ACRFactSetView should not be initialised with a coder")
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
    
    func setStretchableHeight() {
        if inputElement.getHeight() == .stretch {
            if !titleStackView.arrangedSubviews.isEmpty, let lastView = titleStackView.arrangedSubviews.last {
                ACSFillerSpaceManager.configureHugging(view: lastView)
            }
            if !valueStackView.arrangedSubviews.isEmpty, let lastView = valueStackView.arrangedSubviews.last {
                ACSFillerSpaceManager.configureHugging(view: lastView)
            }
        }
    }
    
    private func setupViews() {
        setupFactView()
        addSubview(titleStackView)
        addSubview(valueStackView)
    }
    
    private func setupConstraints() {
        titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: valueStackView.leadingAnchor).isActive = true
        
        let constraint = titleStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.48)
        constraint.priority = .defaultHigh
        constraint.isActive = true

        if let maxWidth = hostConfig.getFactSet()?.title.maxWidth, let maxAllowedWidth = CGFloat(exactly: maxWidth), requiredWidth > maxAllowedWidth {
            titleStackView.widthAnchor.constraint(lessThanOrEqualToConstant: maxAllowedWidth).isActive = true
        } else {
            titleStackView.widthAnchor.constraint(lessThanOrEqualToConstant: requiredWidth + 2).isActive = true
        }

        valueStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        valueStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let widthConstraint = valueStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.48)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true

        // Make the height of each title and value equal
        for (index, elem) in titleStackView.arrangedSubviews.enumerated() {
            let valueArray = valueStackView.arrangedSubviews
            guard let titleView = elem as? ACRTextView, let valueView = valueArray[index] as? ACRTextView else {
                 logError("Element inside FactSetStack is not of type ACRFactTextField")
                 continue
            }
            titleView.heightAnchor.constraint(equalTo: valueView.heightAnchor).isActive = true
        }
    }
    
    private func setupFactView() {
        for fact in inputElement.getFacts() {
            guard let factTitle = getMarkDownFactTitle(from: fact), let factValue = getMarkDownFactValue(from: fact) else { continue }
            
            let titleView = ACRTextView(asFactSetFieldWith: config.hyperlinkColorConfig)
            let valueView = ACRTextView(asFactSetFieldWith: config.hyperlinkColorConfig)
            
            titleView.openLinkCallBack = { urlAddress in
                URLUtils.open(urlAddress)
            }
            
            valueView.openLinkCallBack = { urlAddress in
                URLUtils.open(urlAddress)
            }
            
            // If not markdown use plain text
            if !factTitle.result.isHTML {
                titleView.string = fact.getTitle() ?? ""
            } else {
                titleView.setAttributedString(str: factTitle.textString)
            }
            if !factValue.result.isHTML {
                valueView.string = fact.getValue() ?? ""
            } else {
                valueView.setAttributedString(str: factValue.textString)
            }
            
            if titleView.canBecomeKeyView || valueView.canBecomeKeyView {
                hasLink = true
            }
            
            if let colorHex = hostConfig.getForegroundColor(style, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
                titleView.textColor = textColor
                valueView.textColor = textColor
            }
            
            if !(titleView.string.isEmpty) || !(valueView.string.isEmpty) {
                titleStackView.addArrangedSubview(titleView)
                requiredWidth = max(titleView.attributedString().size().width + 10, requiredWidth)
                valueStackView.addArrangedSubview(valueView)
            }
        }
    }
    
    private func getMarkDownFactTitle(from fact: ACSFact) -> (result: ACSMarkdownParserResult, textString: NSAttributedString)? {
        guard let rootView = rootView else { return nil }
        let textProperties = BridgeTextUtils.convertFact(toRichTextElementProperties: fact)
        
        let titleMarkdownParserResult = BridgeTextUtils.processText(from: fact, hostConfig: hostConfig, isTitle: true)
        let titleMarkdownString = TextUtils.getMarkdownString(for: rootView, with: titleMarkdownParserResult)
        let titleAttributedContent = TextUtils.addFontProperties(attributedString: titleMarkdownString, textProperties: textProperties, hostConfig: hostConfig)
        let titleBoldContent = TextUtils.addBoldProperty(attributedString: titleAttributedContent, textProperties: textProperties, hostConfig: hostConfig)
        return (titleMarkdownParserResult, titleBoldContent)
    }
    
    private func getMarkDownFactValue(from fact: ACSFact) -> (result: ACSMarkdownParserResult, textString: NSAttributedString)? {
        guard let rootView = rootView else { return nil }
        let textProperties = BridgeTextUtils.convertFact(toRichTextElementProperties: fact)
        
        let valueMarkdownParserResult = BridgeTextUtils.processText(from: fact, hostConfig: hostConfig, isTitle: false)
        let valueMarkdownString = TextUtils.getMarkdownString(for: rootView, with: valueMarkdownParserResult)
        let valueAttributedContent = TextUtils.addFontProperties(attributedString: valueMarkdownString, textProperties: textProperties, hostConfig: hostConfig)
        return (valueMarkdownParserResult, valueAttributedContent)
    }
}

extension ACRFactSetView: AccessibleFocusView {
    var validKeyView: NSView? {
        return titleStackView.arrangedSubviews.first
    }
    
    func setupInternalKeyviews() {
        weak var lastKeyView: ACRTextView?
        for index in 0..<titleStackView.arrangedSubviews.count {
            guard let title = titleStackView.arrangedSubviews[index] as? ACRTextView, let value = valueStackView.arrangedSubviews[index] as? ACRTextView else { continue }
            if let lastKeyView = lastKeyView {
                lastKeyView.exitView = title
                lastKeyView.setupInternalKeyviews()
            }
            title.exitView = value
            title.setupInternalKeyviews()
            lastKeyView = value
        }
        lastKeyView?.exitView = self.exitView
        lastKeyView?.setupInternalKeyviews()
    }
}
